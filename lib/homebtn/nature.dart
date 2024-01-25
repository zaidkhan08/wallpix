import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Nature extends StatefulWidget {
  @override
  _NatureState createState() => _NatureState();
}

class _NatureState extends State<Nature> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    // Fetch floral images from Unsplash API when the widget is initialized
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=30&query=nature'), // Added query parameter for the keyword "floral"
        headers: {
          'Authorization': 'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          // Extract regular-sized image URLs from the API response
          imageUrls = List<String>.from(data.map((item) => item['urls']['regular'] as String));
        });
      } else {
        print('Error fetching images: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching images: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nature Images'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.5,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage(imageUrls[index]),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Nature(),
  ));
}
