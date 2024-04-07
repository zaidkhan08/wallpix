import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
                    onPressed: () {
                      _saveImage(widget.image);
                    },
                    child: const Text('Save Image'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage(Uint8List image) async {
    // Convert Uint8List to XFile
    //final tempImage = XFile.fromData(image);

    // Request storage permission
    //await Permission.storage.request();

    // Save image to gallery
    final imagePath = await ImageGallerySaver.saveImage(
      image,
      name: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    // Show successful message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image Saved to Gallery'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green[600],
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
