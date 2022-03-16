import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_adoption/Database/db_firestore.dart';
import 'package:pet_adoption/Pages/center.dart';
import 'package:pet_adoption/Pages/home.dart';

class LoginAuth {
  Db db = Db();

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential receipt =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (receipt.additionalUserInfo!.isNewUser) {
        await db.saveAdminData({
          'id': FirebaseAuth.instance.currentUser!.uid,
          'name': FirebaseAuth.instance.currentUser!.displayName,
          'email': FirebaseAuth.instance.currentUser!.email,
          'photoUrl': FirebaseAuth.instance.currentUser!.photoURL,
        }, FirebaseAuth.instance.currentUser!.uid);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => UserDetails()));
        print('New User');
      } else {
        log("User already exists");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      return receipt;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
