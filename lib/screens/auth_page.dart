import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walllhang/all_images.dart';
import 'package:walllhang/myHomePage.dart';
import 'package:walllhang/login.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          // user is logged in
          if (snapshot.hasData){
            return MyHomePage(title: 'Wallpaper App',);
          }
          // user is NOT logged in
          else{
            return loginView();
          }
        },
      ),
    );
  }
}
