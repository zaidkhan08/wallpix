import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:walllhang/Widgets/button_tile.dart';
import 'package:walllhang/Widgets/my_button.dart';
import 'package:walllhang/Widgets/my_textField.dart';
import 'package:walllhang/screens/auth_service.dart';
import 'package:walllhang/utils/userRepo.dart';


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
  final _userRepo = UserRepo(FirebaseFirestore.instance);


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
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );

        // get the user's ID
        final String userId = userCredential.user!.uid;

        // add 200 pixCoins to the user's account
        await _userRepo.addUsersCoins(userId: userId, pixCoins: 200);


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
      // ERROR
      showErrorMsg(e.message.toString());
    }

  }

  void showErrorMsg(String message){
    print('Showing error message: $message');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Failed to Register"),
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
                const SizedBox(height: 20,),

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google sign in
                    button_tile(
                        imagePath: 'lib/images/google.png',
                      onTap: () => AuthService().signInWithGoogle(),
                    ),

                    SizedBox(width: 25,),

                    // facebook sign in
                    button_tile(
                        imagePath: 'lib/images/facebook2.png',
                      onTap: () {},
                    )
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
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
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
