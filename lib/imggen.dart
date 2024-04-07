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
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        await convertTextToImage(textController.text, context);

        // Deduct coins after the generation is successful
        await _userRepo.deductCoins(userId, 50);
        _loadUserCoins();
      } catch (e) {
        // If image generation fails, show an error dialog
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
          await _userRepo.addCoins(userId, 50);
          _loadUserCoins();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
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
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0XFF9DB2BF),
                        ),
                        onPressed: generateImage,
                        child: isGenerating
                            ? const SizedBox(
                                height: 15,
                                width: 70,
                                child: CircularProgressIndicator(
                                    color: Colors.black))
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
