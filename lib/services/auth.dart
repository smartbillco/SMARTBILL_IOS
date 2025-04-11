import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartbill/screens/dashboard/dashboard.dart';
import 'package:smartbill/screens/home/home_screen.dart';
import 'package:smartbill/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthService {

  //Declaring an instance of firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseConnection db = DatabaseConnection();


  //Stablish stream of user
  Stream<User?> get user {
    return _auth.authStateChanges();
  }


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

          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DashboardScreen()), (r) => false);

        },
        verificationFailed: (FirebaseException e) {
          codeErrorCallback(e.message ?? "Authentication failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) async {
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {}
        );

    } catch(e) {
      print(e);

    }

  }

  //Sign in with phone number
  Future<User?> signInWithCode(String verificationId, String smsCode) async {

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;

    } catch (e) {
      return null;
    }

  }

  //Log out of Firebase
  Future logout(BuildContext context) async {

    try {
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (r) => false);

    } catch(e) {
      print("THERE WAS AN ERROR: $e");
    }
    

  }

  //Delete account
  Future deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;


    try {  

      if(user != null) {
        await user.delete();
        await firestore.collection('users').doc(user.uid).delete();
        await db.deleteDb();
        print("Account deleted");
      }

    } catch(e) {
      print("Errorrrrrr: $e");
    }
  }

}