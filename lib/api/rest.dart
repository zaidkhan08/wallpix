// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walllhang/screens/second_screen.dart';

Future<dynamic> convertTextToImage(String prompt, BuildContext context) async {
  Uint8List imageData = Uint8List(0);

  // Define multiple API keys
  List<String> apiKeys = [
    'Bearer sk-9YxWlDdDOlaQiug35oq69B70DN6QGNDyd0Wc00JROykOp3sK',
    // Add more API keys as needed
  ];

  // Keep track of the current API key index
  int currentApiKeyIndex = 0;

  const baseUrl = 'https://api.stability.ai';
  final url = Uri.parse('$baseUrl/v1alpha/generation/stable-diffusion-v1-6/text-to-image');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': apiKeys[currentApiKeyIndex],
        'Accept': 'image/png',
      },
      body: jsonEncode({
        'cfg_scale': 15,
        'clip_guidance_preset': 'FAST_BLUE',
        'height': 1024,
        'width': 512,
        'samples': 1,
        'steps': 150,
        'seed': 0,
        'style_preset': "3d-model",
        'text_prompts': [
          {
            'text': prompt,
            'weight': 1,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      imageData = Uint8List.fromList(response.bodyBytes);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(image: imageData),
        ),
      );
      return response.bodyBytes;
    } else {
      // Print detailed error information
      print('Request failed with status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // If the current API key reached its limit, switch to the next one
      if (response.statusCode == 403) {
        currentApiKeyIndex = (currentApiKeyIndex + 1) % apiKeys.length;
        // Retry the request with the new API key
        return convertTextToImage(prompt, context);
      }
      return null;
    }
  } catch (e) {
    // Print exception details
    print('Exception: $e');

    // If an exception occurs, switch to the next API key and retry
    currentApiKeyIndex = (currentApiKeyIndex + 1) % apiKeys.length;
    return null;
  }
}