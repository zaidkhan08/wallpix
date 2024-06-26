import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walllhang/api/rest.dart';
import 'package:walllhang/plans.dart';
import 'package:walllhang/utils/userRepo.dart';

void main() => runApp(const AIApp());

class AIApp extends StatelessWidget {
  const AIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: AiPage(),
        debugShowCheckedModeBanner: false,
      );
}

class AiPage extends StatefulWidget {
  const AiPage({Key? key}) : super(key: key);

  @override
  _AiPageState createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final textController = TextEditingController();
  final _userRepo = UserRepo(FirebaseFirestore.instance);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userId = "";
  int coins = 0; // Initial number of coins
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadUserCoins();
    Timer.periodic(const Duration(seconds: 15), (Timer t) => _loadUserCoins());
  }

  // get user ID of the user
  Future<String?> getUserId() async {
    User? user = _auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      print('No user is currently signed in');
      return null;
    }
  }

  // load coins for the particular user
  Future<void> _loadUserCoins() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String? userId = await getUserId();
      if (userId != null) {
        print('User ID: $userId'); // print the user ID
        int coins = await _userRepo.checkPixCoins(userId, 200);
        print('Coins: $coins');
        setState(() {
          this.userId = userId;
          this.coins = coins;
        });
      } else {
        print('User not found');
      }
    } else {
      print('User is not signed in or email is not verified');
    }
  }

  Future<bool> convertTextToImageAndCheckResult(String text, BuildContext context) async {
    // Call the convertTextToImage function
    final uint8List = await convertTextToImage(text, context);

    // Check if the uint8List is not null
    if (uint8List!= null) {
      // The function executed successfully : return true
      return true;
    } else {
      // The function did not execute successfully: return false
      return false;
    }
  }

  // Image Generation through stability diffusion
  void generateImage() async {
    var initialCoins = coins;
    // Subtract 50 coins if there are enough coins
    if (coins >= 50) {
      setState(() {
        isGenerating = true;
      });

      try {
        // Attempt image generation
        bool success = await convertTextToImageAndCheckResult(textController.text, context);

        if (success) {
          // Deduct coins after successful image generation
          await _userRepo.deductCoins(userId, 50);
          _loadUserCoins();
        } else {
          // Show an error dialog if image generation fails
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Failed to Generate Image"),
                content: const Text(
                    "An error occurred while generating the image."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print(e);
        showDialog(
          context: context,
          builder: (BuildContext context) {

            return AlertDialog(
              title: const Text("Failed to Generate Image"),
              content:
                  const Text("An error occurred while generating the image."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );


        // If the coins have been deducted, add them back to avoid losing coins
        if (coins < initialCoins) {
          print("$coins < $initialCoins");
        }
      } finally {
        setState(() {
          isGenerating = false;
        });
      }
    } else {
      // Show a message if there are not enough coins
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Not Enough Coins"),
            content: const Text("You don't have enough coins."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Enter your prompt',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelStyle: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF9DB2BF),
                        ),
                        onPressed: generateImage,
                        child: isGenerating
                            ? const SizedBox(
                                height: 25,
                                width: 25,
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.black),
                                ))
                            : const Text('Generate Image',
                                style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20.0,
                right: 20.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Plans()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Plans()),
                            );
                          },
                          child: Text(
                            '$coins',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        const Icon(
                          Icons.control_point,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
