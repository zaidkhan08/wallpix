import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walllhang/Widgets/button_tile.dart';
import 'package:walllhang/Widgets/my_button.dart';
import 'package:walllhang/Widgets/my_textField.dart';


class registerPage extends StatefulWidget {
  final Function()? onTap;
  const registerPage({super.key, required this.onTap});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // user sign up/ Register User Function
  void signUserUp() async {
    // show loading
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    // Try creating the User
    try {
      // check if password and confirm password are same
      if (passwordController.text == confirmPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        // close loading
        Navigator.pop(context);
      }else{
        showErrorMsg('Passwords don\'t match!');
        return;
      }

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
        showErrorMsg('Wrong password');
      }
    }

  }

  void showErrorMsg(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
              backgroundColor: Colors.deepPurpleAccent,
              title: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              )
          );
        }
    );
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
                const SizedBox(height: 20,),

                // LOGO
                // const Icon(
                //   Icons.format_paint_rounded,
                //   size: 100,
                // ),
                //
                Image(
                  image: AssetImage(
                    'lib/images/logo.png',
                  ),
                  height: 70,
                ),


                const SizedBox(height: 20,),

                // welcome message
                Text(
                  'Welcome to Wallpix!',
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

                // confirm password TextField
                my_textField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10,),

                // sign up button
                myButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
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
                      "Already have an Account?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Now",
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
