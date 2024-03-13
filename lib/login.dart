import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walllhang/Widgets/button_tile.dart';
import 'package:walllhang/Widgets/my_button.dart';
import 'package:walllhang/Widgets/my_textField.dart';

import 'screens/forgotPasswordPage.dart';

class loginPage extends StatefulWidget {
  final Function()? onTap;
  loginPage({super.key, required this.onTap});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  //text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // user sign in Function
  void signUserIn() async {
    // show loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    // Try to sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      // close loading
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // close loading
      Navigator.pop(context);
      // WRONG Email
      if (e.code == 'user-not-found') {
        showErrorMsg('Wrong Email');
      }
      // WRONG Password
      else if (e.code == 'wrong-password') {
        showErrorMsg('Wrong Password');
      }
      else {
        showErrorMsg(e.message.toString());
      }
    }
  }

  void showErrorMsg(String message){
    print('Showing error message: $message');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Failed to Login"),
          content: Text(
            message,
            style: const TextStyle(
                color: Color(0xFF03033F)
            ),
          ),
        );
      },
    ).then((value) {
      print('Dialog closed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),

                // LOGO
                // const Icon(
                //   Icons.format_paint_rounded,
                //   size: 100,
                // ),
                //
                const Image(
                  image: AssetImage(
                    'lib/images/logo.png',
                  ),
                  height: 100,
                ),


                const SizedBox(height: 40,),

                // welcome message
                Text(
                    'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20,),

                // email TextField
                my_textField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10,),

                // password TextField
                my_textField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10,),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                            MaterialPageRoute(builder: (context){
                              return ForgotPasswordPage();
                              }
                            ),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10,),

                // sign in button
                myButton(
                  text: 'Sign In',
                  onTap: signUserIn,
                ),

                const SizedBox(height: 40,),

                // or Continue with msg
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                            "Or continue with",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          )
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 40,),
                // google and facebook btn for sign in..
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google sign in
                    button_tile(imagePath: 'lib/images/google.png'),

                    SizedBox(width: 25,),

                    // facebook sign in
                    button_tile(imagePath: 'lib/images/facebook2.png')
                  ],
                ),

                const SizedBox(height: 40,),

                // not a member? register now btn
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Not a member?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                            color: Color(0xff088FBC),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
