import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/my_button.dart';
import '../Widgets/my_textField.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  //text editing controllers
  final forgotEmailController = TextEditingController();

  @override
  void dispose() {
    forgotEmailController.dispose();
    super.dispose();
  }

  // reset password
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: forgotEmailController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
            content: Text("Password reset link sent! Check your Email.")
        );
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
            content: Text(e.message.toString())
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,), onTap: (){ Navigator.pop(context); },),
        centerTitle: true,
        backgroundColor: Color(0xFF03033F),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // enter email msg
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Enter your Email and we will send you a password reset link",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 20,),

          // Enter email for password recovery
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: my_textField(
              controller: forgotEmailController,
              hintText: 'Email',
              obscureText: false,
            ),
          ),
          SizedBox(height: 20,),

          //  reset password button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: myButton(
              text: 'Reset Password',
              onTap: resetPassword,
            ),
          ),
        ],
      ),
    );
  }
}
