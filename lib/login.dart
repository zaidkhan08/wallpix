import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walllhang/Widgets/button_tile.dart';
import 'package:walllhang/Widgets/my_button.dart';
import 'package:walllhang/Widgets/my_textField.dart';

class loginView extends StatelessWidget {
  loginView({super.key});

  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // user sign in Function
  void signUserIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
          
                // logo
                // const Icon(
                //   Icons.format_paint_rounded,
                //   size: 100,
                // ),
                //
                Image(
                  image: AssetImage(
                    'lib/images/logo.png',
                  ),
                  height: 100,
                ),


                const SizedBox(height: 40,),
          
                // welcome message
                Text(
                    'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
          
                const SizedBox(height: 20,),
          
                // username TextField
                my_textField(
                  controller: usernameController,
                  hintText: 'Username',
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
                      Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 10,),
          
                // sign in button
                myButton(
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
                    Text(
                      "Register Now",
                      style: TextStyle(
                          color: Color(0xff088FBC),
                        fontWeight: FontWeight.bold
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
