import 'dart:io';
import 'package:final_year_project/views/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:final_year_project/model/signupdata.dart';
import 'package:final_year_project/services/imageupload.dart';
import 'package:final_year_project/services/otp.dart';
import 'package:final_year_project/views/otpscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:final_year_project/views/constants.dart';
import 'package:final_year_project/widget/main_button.dart';
import 'package:final_year_project/widget/text_field.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late FirebaseMessaging _firebaseMessaging;
  File? _userImage;

  Future<void> printFCM() async {
    print("reached");
    _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmtoken = await _firebaseMessaging.getToken();
    print("the fcm token is ${fcmtoken}");
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _userImage = File(pickedFile.path);
      });
    }
  }

  void signUp() async {
   
    if (_formKey.currentState!.validate()) {
      //upload the img
      String imageUrl = '';

      {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();

        // Reference to the storage root
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference refernceDirImages = referenceRoot.child('Images/');

        Reference referenceImageUpload =
            refernceDirImages.child(uniqueFileName + '.jpg');

        try {
          await referenceImageUpload.putFile(_userImage!);
          imageUrl = await referenceImageUpload.getDownloadURL();
          print('Image uploaded. URL: $imageUrl');
        } catch (error) {
          print('Error uploading image: $error');
        }
      }

      // Retrieve the input values
      String name = userName.text;
      String email = userEmail.text;
      String phone = '+977${userPh.text}';
      String password = userPass.text;
      String userProfile = imageUrl;
      print('the image url here is $userProfile');
      SignupData signupdata = SignupData(
        name: name,
        username: phone,
        password: password,
        confirmPassword: confirmPass.text,
        email: email,
        userProfile: userProfile,
      );

      OtpServices otpservice = OtpServices();
      String? verificationId = await otpservice.sendOTPToPhoneNumber(phone);

      Navigator. push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OTPVerificationScreen(verificationId!, signupdata),
        ),
      );
    }
  }

  TextEditingController userName = TextEditingController();
  TextEditingController userPass = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPh = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 186, 174),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Choose Image Source"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.camera);
                                },
                                child: Text("Camera"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _pickImage(ImageSource.gallery);
                                },
                                child: Text("Gallery"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _userImage != null
                          ? FileImage(_userImage!) as ImageProvider<Object>?
                          : null,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'Create new account',
                    style: headline1,
                  ),
                  SpaceVH(height: 10.0),
                  Text(
                    'Please fill in the form to continue',
                    
                      style: headline3.copyWith(color: Colors.blue), 
                  ),
                  SpaceVH(height: 50.0),
                  textFild(
                    controller: userName,
                    icon: Icons.person,
                   
                    keyBordType: TextInputType.name,
                    hintTxt: 'Full Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null; // The input is valid
                    },
                  ),
                  SizedBox(height: 10),
                  textFild(
                    controller: userEmail,
                    keyBordType: TextInputType.emailAddress,
                    icon: Icons.email,
                    hintTxt: 'Email Address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      } else if (!isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null; // The input is valid
                    },
                  ),
                  SizedBox(height: 10),
                  textFild(
                    controller: userPh,
                    icon: Icons.phone,
                    keyBordType: TextInputType.phone,
                    hintTxt: 'Phone Number',
                    prefixText: '+977', // Add the prefix text here
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (value.length != 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null; // The input is valid
                    },
                  ),
                  SizedBox(height: 10),
                  textFild(
                    controller: userPass,
                    isObs: true,
                    icon: Icons.lock,
                    keyBordType: TextInputType.text,
                    hintTxt: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null; // The input is valid
                    },
                  ),
                  SizedBox(height: 10),
                  textFild(
                    controller: confirmPass,
                    isObs: true,
                    icon: Icons.lock,
                    keyBordType: TextInputType.text,
                    hintTxt: 'Confirm Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      } else if (value != userPass.text) {
                        return 'Passwords do not match';
                      }
                      return null; // The input is valid
                    },
                  ),
                  SpaceVH(height: 60.0),
                  Mainbutton(
                    onTap: () {
                      signUp();
                      
                    },
                    text: 'Sign Up',
                    btnColor: Color.fromARGB(255, 98, 147, 227),
                  ),
                  SpaceVH(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                       Navigator.push(context as BuildContext,

 MaterialPageRoute(builder: ((context) => LoginScreen())));
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Have an account? ',
                          style: headline.copyWith(
                            fontSize: 14.0,
                          ),
                        ),
                        TextSpan(
                          text: ' Sign In',
                          style: headlineDot.copyWith(
                            fontSize: 14.0,
                          ),
                        ),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
   
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }
}
