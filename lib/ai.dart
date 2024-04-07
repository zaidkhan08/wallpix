import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiImageGenerator extends StatefulWidget {
  @override
  _AiImageGeneratorState createState() => _AiImageGeneratorState();
}

class _AiImageGeneratorState extends State<AiImageGenerator> {
  TextEditingController _textInputController = TextEditingController();
  String _imageUrl = '';
  String apiKey = 'sk-9YxWlDdDOlaQiug35oq69B70DN6QGNDyd0Wc00JROykOp3s'; // Replace with your Stability.AI API key

  Future<void> _generateImage() async {
    final text = _textInputController.text;
    final apiUrl = 'https://api.stability.ai/v1/generate_image';  // Replace with the actual Stability.AI API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'text': text}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final imageUrl = jsonResponse['image_url'] as String;
        setState(() {
          _imageUrl = imageUrl;
        });
      } else {
        print('Failed to generate image: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textInputController,
              decoration: InputDecoration(
                labelText: 'Enter text for image generation',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateImage,
              child: Text('Generate Image'),
            ),
            SizedBox(height: 16),
            _imageUrl.isNotEmpty
                ? Image.network(
              _imageUrl,
              fit: BoxFit.contain,
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AiImageGenerator(),
  ));
}
