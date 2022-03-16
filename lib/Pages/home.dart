import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/Pages/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FirebaseAuth.instance.signOut().whenComplete(() {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          });
        },
        child: Center(
          child: Text("Home Page"),
        ),
      ),
    );
  }
}
