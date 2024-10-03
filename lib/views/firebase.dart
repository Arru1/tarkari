import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _imageFile;
  String imageUrl = '';

  final ImagePicker _picker = ImagePicker();


  late FirebaseMessaging _firebaseMessaging;

  Future<void> printFCM() async {
    print("reached");
    _firebaseMessaging = FirebaseMessaging.instance;
    String? fcmtoken = await _firebaseMessaging.getToken();
    print("the fcm token is ${fcmtoken}");
  }

  Future<void> _getImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.camera);
    print("hello");
    print((selectedImage));

    setState(() {
      if (selectedImage != null) {
        _imageFile = File(selectedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }



Future<String?> sendOTPToPhoneNumber() async {
  String? phone='+9779869320114';
  print(phone);
    Completer<String?> completer = Completer<String?>();
    bool completed = false; // Flag to track completion

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        if (!completed) {
          completed = true;
          // Process verificationCompleted if needed
          // For example, you might want to sign in the user directly here
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completed) {
          completed = true;
          completer.completeError(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!completed) {
          completed = true;
          completer.complete(verificationId);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!completed) {
          completed = true;
          completer.completeError('Auto retrieval timeout');
        }
      },
    );

    return completer.future;
  }

  Future<bool> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Use the credential to check if the code is valid
      await FirebaseAuth.instance.signInWithCredential(credential);

      // If the code is valid, return true
      return true;
    } catch (e) {
      // If the code is invalid or an error occurs, return false
      print('Error verifying OTP: $e');
      return false;
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _getImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 2, color: Colors.blue),
                ),
                child: _imageFile != null
                    ? ClipOval(
                        child: Image.file(
                          _imageFile!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.blue,
                      ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                printFCM();
                if (_imageFile != null) {
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  // Reference to the storage root
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference refernceDirImages =
                      referenceRoot.child('Images/');

                 
                  Reference referenceImageUpload =
                      refernceDirImages.child(uniqueFileName + '.jpg');

                 
                  try {
                    await referenceImageUpload.putFile(_imageFile!);
                    imageUrl = await referenceImageUpload.getDownloadURL();
                    print('Image uploaded. URL: $imageUrl');
                  } catch (error) {
                    print('Error uploading image: $error');
                  }
                } else {
                  print('No image selected.');
                }
              },
              child: Text('Upload Image'),
            ),
            SizedBox(height:20),
            ElevatedButton(onPressed: (){
              sendOTPToPhoneNumber();

            }, child: Text('Send Otp'))
          ],
        ),
      ),
    );
  }
}
