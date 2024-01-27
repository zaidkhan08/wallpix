// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:walllhang/screens/second_screen.dart';
import 'package:walllhang/utils/dialog.dart';

Future<dynamic> convertTextToImage(
    String prompt,
    BuildContext context,
    ) async {
  Uint8List imageData = Uint8List(0);

  const baseUrl = 'https://api.stability.ai';
  final url = Uri.parse(
      '$baseUrl/v1alpha/generation/stable-diffusion-v1-6/text-to-image');

  // Make the HTTP POST request to the Stability Platform API
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization':'sk-dXhKviD7EpZuXf1QNEDEiWhNwZzaWrdJ4mjkUrmgif1zOA3V'
      //add ypur secreat key here
          'Bearer sk-dXhKviD7EpZuXf1QNEDEiWhNwZzaWrdJ4mjkUrmgif1zOA3V',
      'Accept': 'image/png',
    },
    body: jsonEncode({
      'cfg_scale': 15,
      'clip_guidance_preset': 'FAST_BLUE',
      'height': 512,
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
    try {
      imageData = (response.bodyBytes);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondScreen(image: imageData),
          ));
      return response.bodyBytes;
    } on Exception {
      return showErrorDialog('Failed to generate image', context);
    }
  } else {
    return showErrorDialog('Failed to generate image', context);
  }
}
