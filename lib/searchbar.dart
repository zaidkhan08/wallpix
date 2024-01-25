import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late FocusNode _focusNode;
  TextEditingController _searchController = TextEditingController();
  List<String> unsplashImages = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _focusNode.requestFocus();
      });
      fetchRandomUnsplashImages();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchRandomUnsplashImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=8'),
        headers: {
          'Authorization': 'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA',
        },
      );

      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        unsplashImages = List<String>.from(data.map((item) => item['urls']['regular'] as String));
      });
    } catch (error) {
      print('Error fetching images: $error');
    }
  }

  Future<void> fetchUnsplashImages(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=70&query=$query'),
        headers: {
          'Authorization': 'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA',
        },
      );

      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        unsplashImages = List<String>.from(data.map((item) => item['urls']['regular'] as String));
      });
    } catch (error) {
      print('Error fetching images: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(color: Colors.blue),
          onSubmitted: (query) {
            query.isEmpty ? fetchRandomUnsplashImages() : fetchUnsplashImages(query);
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white38),
            contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white54,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: 0.5,
          ),
          itemCount: unsplashImages.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(unsplashImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Search(),
  ));
}
