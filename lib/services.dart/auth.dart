import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbill/screens/dashboard/dashboard.dart';


class AuthService {

  //Declaring an instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;


  //Authentication with phone number
  Future<void> verifyPhone({required BuildContext context, required String phone,
    required Function(String verificationId) codeSentCallback,
    required Function(String message) codeErrorCallback
  }) async {

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {

          await _auth.signInWithCredential(credential);

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (Route<dynamic> route) => false,);

          print("COMPLETED AUTO AUTENTICATION");

        },
        verificationFailed: (FirebaseException e) {
          codeErrorCallback(e.message ?? "Authentication failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {}
        );

    } catch(e) {
      print(e);

    }

  }

  Future<User?> signInWithCode(String verificationId, String smsCode) async {

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;

    } catch (e) {
      print("There was an error with the code");
      return null;
    }

  }

  


}