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
  int currentPage = 1; // Track the current page number

  // Add multiple API keys
  List<String> apiKeys = [
    'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA',
    'Client-ID wbMIOCWddNHjYubR1VHDbJdHPKlut2uT1JopGVQ6rh4',
    'Client-ID T7iGw4T2nvs77ju1uNntDTY3Nl4vBIz2Jk-tzjX06tw',
  ];

  int currentApiKeyIndex = 0;
  late Timer apiSwitchTimer;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    apiSwitchTimer = Timer.periodic(Duration(minutes: 30), (timer) {
      switchApiKey();
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _focusNode.requestFocus();
      });
      fetchUnsplashImages();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    apiSwitchTimer.cancel();
    super.dispose();
  }

  Future<void> fetchUnsplashImages([String? query]) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=40&page=$currentPage${query != null ? "&query=$query" : ""}'),
        headers: {
          'Authorization': apiKeys[currentApiKeyIndex],
        },
      );

      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        unsplashImages.addAll(List<String>.from(data.map((item) => item['urls']['regular'] as String)));
      });
      currentPage++; // Increment the page number after fetching images
    } catch (error) {
      print('Error fetching images: $error');
      switchApiKey();
    }
  }

  void switchApiKey() {
    currentPage = 1; // Reset page number when switching API keys
    currentApiKeyIndex = (currentApiKeyIndex + 1) % apiKeys.length;
    fetchUnsplashImages();
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
          style: TextStyle(color: Colors.white),
          onSubmitted: (query) {
            unsplashImages.clear(); // Clear existing images when submitting a new query
            fetchUnsplashImages(query);
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white24),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
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
