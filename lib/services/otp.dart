import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class OtpServices{
Future<String?> sendOTPToPhoneNumber(String phoneNum) async {
 // String? phone='+9779869320114';
 // print(phone);
    Completer<String?> completer = Completer<String?>();
    bool completed = false; 

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNum,
      verificationCompleted: (PhoneAuthCredential credential) {
        if (!completed) {
          completed = true;
      
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









}