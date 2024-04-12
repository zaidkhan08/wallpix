import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:walllhang/imageView.dart';

class catImageView extends StatefulWidget {
  final String categoryImg;
  final String categoryName;
  const catImageView({super.key, required this.categoryImg, required this.categoryName});
  @override
  State<catImageView> createState() => _catImageViewState();
}

class _catImageViewState extends State<catImageView> {

  List<String> unsplashImages = [];
  // Add multiple API keys
  List<String> apiKeys = [
    'Client-ID QRZelDFt0UV-3JcxQa9Ts8N7Y4YCMWr00reUds0Mas0', // New Key - categoryImageView
    'Client-ID tdT9qLblRpFSSRxUgw3ISf9yCepEigVEwObaGInV3v8', // New Key - categoryImageView
    'Client-ID CjIXyDOHe3ez0aMycHa5hCafSP2PpEByRfdT3LUxjhk', // New key - categoryImageView
  ];
  int currentApiKeyIndex = 0;
  late Timer apiSwitchTimer;
  int currentPage = 1; // Track the current page number

  @override
  void initState() {
    super.initState();

    apiSwitchTimer = Timer.periodic(Duration(minutes: 30), (timer) {
      switchApiKey();
    });
    unsplashImages.clear(); // Clear existing images when submitting a new query
    fetchUnsplashImages(widget.categoryName);
  }

  @override
  void dispose() {
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
    String query = widget.categoryName;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Stack(
                children: [
                  Image.network(
                    widget.categoryImg,
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black38,
                  ),
                  Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 35,),
                          const Text(
                            "Category",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            widget.categoryName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
          
              // category wise searched images
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.71,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: unsplashImages.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: ((context, index) => GridTile(
                        child: InkWell(
                            onTap: (){
                              // Navigate to the second screen when tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ImageView(imgUrl: unsplashImages[index], imgName: "Image",)),
                              );
                            },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    unsplashImages[index]
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    )),
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