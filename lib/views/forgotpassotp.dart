// otp_verification_screen.dart


import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/model/signupdata.dart';

import 'package:final_year_project/services/otp.dart';
import 'package:final_year_project/views/loginscreen.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  final String verificationId;
  String phoneNum;

  ForgotPass(this.verificationId, this.phoneNum);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<ForgotPass> {
  List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  String getOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your mobile',
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 40.0,
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
  onPressed: () async {
    setState(() {}); // Trigger a rebuild to show loader
    String otp = getOtp();
    OtpServices otpservice = OtpServices();
    if (await otpservice.verifyOTP(widget.verificationId, otp)) {
      print('verified');
      Navigator.pop(context); // Dismiss OTP dialog
      TextEditingController newPasswordController = TextEditingController();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Text('Enter New Password'),
                content: TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter new password',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss dialog
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {}); // Trigger a rebuild to show loader
                      // Validate password length
                      String newPassword = newPasswordController.text;
                      if (newPassword.length >= 6) {
                        SignupData signupdata = SignupData(
                          username: widget.phoneNum,
                          password: newPassword,
                        );

                        Apiservice ap = ApiserviceImpl();
                        if (await ap.changePassword(signupdata)==true) {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Password changed successfully'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Server Error, please try again'),
                            ),
                          );
                        }
                        Navigator.of(context).pop(); // Dismiss dialog
                      } else {
                        // Show error message for invalid password length
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Password must be at least six digits.'),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      print("not verified");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect OTP entered'),
        ),
      );
    }
  },
  child: Text('Verify OTP'),
),

          ],
        ),
      ),
    );
  }
}
