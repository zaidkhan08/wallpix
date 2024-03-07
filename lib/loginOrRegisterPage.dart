import 'package:flutter/material.dart';
import 'package:walllhang/login.dart';
import 'package:walllhang/register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {

  // initially show Login Page
  bool showLoginPage = true;

  // toggle between Login and Register
  void togglePage(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return loginPage(
        onTap: togglePage,
      );
    } else {
      return registerPage(
        onTap: togglePage
      );
    }
  }
}

