import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondScreen extends StatefulWidget {
  final Uint8List image;

  const SecondScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF27374D),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: 370, // Adjust the width as needed
                  height: 600, // Adjust the height as needed
                  child: Image.memory(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _saveImage,
                    child: Text('Save Image'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveImage() {
    // Implement your logic to save the image here
  }
}
