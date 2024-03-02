import 'package:flutter/material.dart';
import 'package:walllhang/api/rest.dart';

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

  int coins = 100; // Initial number of coins

  bool isLoading = false;

  void generateImage() async {
    // Subtract 50 coins if there are enough coins
    if (coins >= 50) {
      setState(() {
        isLoading = true;
      });

      try {
        // Attempt image generation
        await convertTextToImage(textController.text, context);
      } catch (e) {
        // If image generation fails, show an error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Failed to Generate Image"),
              content: Text("An error occurred while generating the image."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } finally {
        // Deduct coins after the generation is completed (successful or not)
        setState(() {
          coins -= 50;
          isLoading = false;
        });
      }
    } else {
      // Show a message if there are not enough coins
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Not Enough Coins"),
            content: Text("You don't have enough coins."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
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
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF9DB2BF),
                    ),
                    onPressed: generateImage,
                    child: isLoading
                        ? const SizedBox(
                        height: 15,
                        width: 15,
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
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 5.0),
                  Text(
                    '$coins',
                    style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5.0),
                  Icon(
                    Icons.control_point,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
