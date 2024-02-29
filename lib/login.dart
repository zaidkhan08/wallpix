import 'package:flutter/material.dart';
import 'package:walllhang/Widgets/button_tile.dart';
import 'package:walllhang/Widgets/my_button.dart';
import 'package:walllhang/Widgets/my_textField.dart';

class loginView extends StatelessWidget {
  loginView({Key? key});

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // User sign-in Function
  void signUserIn() {}

  bool _isObscure = true; // Track password visibility

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
                SizedBox(height: 40),
                Image(
                  image: AssetImage('lib/images/logo.png'),
                  height: 100,
                ),
                SizedBox(height: 40),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                // Username TextField
                my_textField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                SizedBox(height: 10),
                // Password TextField
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    my_textField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: _isObscure,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Toggle password visibility
                        _isObscure = !_isObscure;
                        // Refresh UI
                        (context as Element).markNeedsBuild();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: Icon(
                          _isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Forgot password?
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
                SizedBox(height: 10),
                // Sign-in button
                myButton(
                  onTap: signUserIn,
                ),
                SizedBox(height: 40),
                // Or Continue with message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
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
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40),
                // Google and Facebook buttons for sign-in
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google sign-in
                    button_tile(imagePath: 'lib/images/google.png'),
                    SizedBox(width: 25),
                    // Facebook sign-in
                    button_tile(imagePath: 'lib/images/facebook2.png')
                  ],
                ),
                SizedBox(height: 40),
                // Not a member? Register now button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      "Register Now",
                      style: TextStyle(
                        color: Color(0xff088FBC),
                        fontWeight: FontWeight.bold,
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
