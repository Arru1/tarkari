// otp_verification_screen.dart

import 'dart:io';

import 'package:final_year_project/api/apiservice.dart';
import 'package:final_year_project/api/apiserviceimpl.dart';
import 'package:final_year_project/model/signupdata.dart';

import 'package:final_year_project/services/imageupload.dart';
import 'package:final_year_project/services/otp.dart';
import 'package:final_year_project/views/loginscreen.dart';
import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;
  SignupData signupdata;
  
  OTPVerificationScreen( this.verificationId, this.signupdata);
  
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
 
  List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

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
              onPressed: ()async {
                // Handle OTP verification logic here
                String otp = getOtp();
                OtpServices otpservice = new OtpServices();
                if(await otpservice.verifyOTP(widget.verificationId, otp)){
                  print("verfied");
                 // ImgUpload.imageUpload(widget._userImage);
                  //i want signupdto to be accessed here
                  // print(widget.signupdata.confirmPassword);
                  // print(widget.signupdata.userProfile);
                  // print(widget.signupdata.username);
                  print('another image url in otp verification screen is${widget.signupdata.userProfile}');
                  Apiservice apiservice = ApiserviceImpl();
                 if (await apiservice.saveUsers(widget.signupdata)==true)
                 {
        print("sucessfully saved");
    Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => LoginScreen()),
  (route) => false, 
);

                 }
                 else{
                  print("unable to save data");
                 }
                }
                else{
                  print("not verified");
                }
               // print('Entered OTP: $otp');
                // Add your OTP verification logic here
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
