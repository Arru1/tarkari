import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/main.dart';
import 'package:final_year_project/model/signupdata.dart';
import 'package:final_year_project/services/otp.dart';
import 'package:final_year_project/views/admindashboard.dart';
import 'package:final_year_project/views/explore.dart';
import 'package:final_year_project/views/footer.dart';
import 'package:final_year_project/views/product_details_page.dart';
import 'package:final_year_project/views/forgotpassotp.dart';
import 'package:final_year_project/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isRememberMe = false;
  bool _isPasswordVisible = false;
  TextEditingController userPh = TextEditingController();
  TextEditingController Pass = TextEditingController();

  void login() async {
    if (_formKey.currentState?.validate() ?? false) {
      String phoneNum = '+977${userPh.text}';
      String password = Pass.text;

      SignupData logindata = SignupData(username: phoneNum, password: password);
      Apiservice apiservice = ApiserviceImpl();
      String token = await apiservice.loginUser(logindata);

      if (token.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(MyAppState.TOKEN, token);
        prefs.setString(MyAppState.PHONENUMBER, phoneNum);
        prefs.setBool(MyAppState.KEYLOGIN, true);

        SignupData? responseData = await apiservice.getUserInfo();
        prefs.setString(MyAppState.NAME, responseData?.name ?? "");
        prefs.setString(
            MyAppState.USERPROFILE, responseData?.userProfile ?? '');
        prefs.setString(MyAppState.EMAIL, responseData?.email ?? '');
        // prefs.setString(MyAppState.ID, responseData!.id.toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Footer()),
        );
      } else {
        print("Unable to login");
      }
    }
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "PhoneNumber",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.phone,
                  color: Color(0xff5ac18e),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, left: 1),
                child: Text(
                  "+977",
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 14, left: 8),
                  child: TextFormField(
                    controller: userPh,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Your Number',
                      hintStyle: TextStyle(color: Colors.black38),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60,
          child: TextFormField(
            controller: Pass,
            //obscureText: true,
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            style: TextStyle(
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff5ac18e),
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.black38),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black38),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black38),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForgetPasswordBtn() {
  return Container(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      int flag = 0; // Initialize flag outside of showDialog
      TextEditingController phoneNumberController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Your Phone Number'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+977',
                      ),
                    ),
                    SizedBox(height: 20), // Adjust the space as needed
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {}); // Trigger a rebuild to show loader
                        Apiservice apis = ApiserviceImpl();
                        var response = await apis.forgotPassword(phoneNumberController.text);
                        if (response == null) {
                           Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Enter valid phone number'),
                            ),
                          );
                        } else {
                          flag = 1; // Set flag to 1 when response is not null
                          Navigator.of(context).pop(); // Dismiss the AlertDialog
                        }
                        if (flag == 1) 
                        {
                          sendotp('+977${phoneNumberController.text}');
                          print('before function : +977${phoneNumberController.text}');
                        
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    },
    style: TextButton.styleFrom(
      padding: EdgeInsets.only(right: 0),
    ),
    child: const Text(
      "Forget Password?",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);


  }

  // Widget buildRememberPass() {
  //   return Container(
  //     height: 20,
  //     child: Row(
  //       children: <Widget>[
  //         Theme(
  //           data: ThemeData(unselectedWidgetColor: Colors.white),
  //           child: Checkbox(
  //             value: isRememberMe,
  //             checkColor: Colors.green,
  //             activeColor: Colors.white,
  //             onChanged: (value) {
  //               setState(() {
  //                 isRememberMe = value!;
  //               });
  //             },
  //           ),
  //         ),
  //         const Text(
  //           "Remember me",
  //           style: TextStyle(
  //               color: Colors.white, fontWeight: FontWeight.bold),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5, backgroundColor: Colors.white,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          if (userPh.text == "12348848" && Pass.text == "admin@farmerzone") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()),
            );
          } else {
            login();
          }
        },
        child: const Text(
          "Login",
          style: TextStyle(
            color: Color.fromARGB(255, 104, 118, 111),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildSignUpBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: "Don\'t have an account? ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: "Sign Up",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 142, 148, 142),
                      Color.fromARGB(255, 142, 148, 142),
                      Color.fromARGB(255, 142, 148, 142),
                      Color.fromARGB(255, 142, 148, 142),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 50),
                        buildEmail(),
                        SizedBox(height: 35),
                        buildPassword(),
                        SizedBox(height: 0),
                        buildForgetPasswordBtn(),
                        //buildRememberPass(),
                        buildLoginBtn(),
                        buildSignUpBtn(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void sendotp(String phone)async {
      OtpServices otpservice = OtpServices();
                          String? verificationId = await otpservice.sendOTPToPhoneNumber(
                            phone,
                          );
                          print(phone);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPass(
                                verificationId!,
                                phone,
                              ),
                            ),
                          );
  }
}
