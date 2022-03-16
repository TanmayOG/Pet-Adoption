import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pet_adoption/Database/auth_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          LoginAuth().signInWithGoogle(context);
        },
        child: Center(
          child: Text("Login Page"),
        ),
      ),
    );
  }
}
