import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:walllhang/imageView.dart';
import 'package:walllhang/categoryImageView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllImages(),
    );
  }
}

class AllImages extends StatefulWidget {
  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  PageController _pageController = PageController();
  List<String> pageViewImages = [
    'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjg0MC0wNi0wOV8xLmpwZw.jpg',
    'https://i.pinimg.com/originals/bd/b2/29/bdb229e4ee8046c922104ae32b99bc17.png',
    'https://cdn.pixabay.com/photo/2017/07/11/03/30/vacation-2492247_1280.jpg',
    'https://i.pinimg.com/originals/5b/12/18/5b12182d594590211cfb4b31f8c2be95.jpg',
  ];

  List<String> pageViewImgName = [
    'Beach',
    'Nature',
    'Vacation',
    'Floral'
  ];

  List<String> gridViewImages = [];
  int _currentPage = 0;
  int _gridViewPage = 1;
  Set<String> uniqueGridViewImages = Set(); // Keep track of unique images

  late Timer _timer;

  // Define multiple API keys
  List<String> apiKeys = [
    'Client-ID wbMIOCWddNHjYubR1VHDbJdHPKlut2uT1JopGVQ6rh4',
    'Client-ID T7iGw4T2nvs77ju1uNntDTY3Nl4vBIz2Jk-tzjX06tw',
    'Client-ID CwMdLxJ1PO6VYY7rugXRZzOAkjrrg4utRo_zI5wlYv4',


  ];

  // Keep track of the current API key index
  int currentApiKeyIndex = 0;

  // Add a boolean variable to check if any API key has succeeded
  bool apiRequestSucceeded = false;

  ScaffoldMessengerState? scaffoldMessenger;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    // Start auto-scrolling
    startAutoScroll();

    // Fetch images from the API for gridViewImages and pageViewImages
    fetchImages();

    // Access the scaffold messenger to show snack bars
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scaffoldMessenger = ScaffoldMessenger.of(context);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void startAutoScroll() {
    const Duration duration = Duration(seconds: 3);

    _timer = Timer.periodic(duration, (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          (_currentPage + 1) % pageViewImages.length,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> fetchImages() async {
    // No need to fetch images as they are added manually
    startAutoScroll(); // Start auto-scrolling after fetching images
  }

  // Remaining code remains the same

  Future<void> fetchPageViewImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=4'),
        headers: {
          'Authorization': apiKeys[currentApiKeyIndex],
        },
      );

      if (response.statusCode == 403) {
        // If the current API key reached its limit, switch to the next one
        switchToNextApiKey();

        // If all API keys have reached their limit, show a message to the user
        if (currentApiKeyIndex == 0) {
          apiRequestSucceeded = false; // Mark API request as failed
          showLimitReachedMessage();
          return;
        }

        // Retry fetching with the new API key
        return fetchPageViewImages();
      }

      final List<dynamic> data = jsonDecode(response.body);
      print('Page View Images Response: $data');

      if (data is List) {
        final List<String> newImages = List<String>.from(data.map((item) {
          if (item is Map<String, dynamic> &&
              item.containsKey('urls') &&
              item['urls'] is Map<String, dynamic>) {
            return item['urls']['regular'] as String;
          } else {
            return ''; // Handle unexpected data structure
          }
        })).where((image) => image.isNotEmpty).toList();

        setState(() {
          pageViewImages = newImages;
        });

        // Mark API request as succeeded
        apiRequestSucceeded = true;
      } else {
        // If the data structure is unexpected, handle it accordingly
        print('Unexpected data structure in API response.');
        // Mark API request as failed
        apiRequestSucceeded = false;
      }
    } catch (error) {
      print('Error fetching page view images: $error');
    }
  }

  Future<void> fetchGridViewImages(int page) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=30&page=$page'),
        headers: {
          'Authorization': apiKeys[currentApiKeyIndex],
        },
      );

      if (response.statusCode == 403 && response.body.contains("OAuth error: The access token is invalid")) {
        // If the access token is invalid, switch to the next API key
        switchToNextApiKey();

        // If all API keys have been tried, show a message to the user
        if (currentApiKeyIndex == 0) {
          apiRequestSucceeded = false; // Mark API request as failed
          showLimitReachedMessage();
          return;
        }

        // Retry fetching with the new API key
        return fetchGridViewImages(page);
      }

      final List<dynamic> data = jsonDecode(response.body);
      print('Grid View Images Response: $data');

      if (data is List) {
        // Filter out duplicate images
        List<String> newImages = List<String>.from(data.map((item) {
          if (item is Map<String, dynamic> &&
              item.containsKey('urls') &&
              item['urls'] is Map<String, dynamic>) {
            return item['urls']['regular'] as String;
          } else {
            return ''; // Handle unexpected data structure
          }
        })).where((image) => image.isNotEmpty).toList();

        setState(() {
          gridViewImages.addAll(newImages);
          uniqueGridViewImages.addAll(newImages);
        });

        // Mark API request as succeeded
        apiRequestSucceeded = true;
      } else {
        // If the data structure is unexpected, handle it accordingly
        print('Unexpected data structure in API response.');
        // Mark API request as failed
        apiRequestSucceeded = false;
      }
    } catch (error) {
      print('Error fetching grid view images: $error');
    }
  }

  void switchToNextApiKey() {
    currentApiKeyIndex = (currentApiKeyIndex + 1) % apiKeys.length;
    // If the next API key is not explicitly mentioned, go back to the first API key
    if (currentApiKeyIndex == 0) {
      print('Switching back to the first API key.');
    }
  }

  void showLimitReachedMessage() {
    // Display a message to inform the user that API limits have been reached
    if (!apiRequestSucceeded) {
      // Show the message only if no API request succeeded
      scaffoldMessenger?.showSnackBar(
        const SnackBar(
          content: Text('All API keys have reached their limit.'),
        ),
      );
      print('All API keys have reached their limit.');
    }
  }

  Future<void> fetchMoreGridViewImages() async {
    _gridViewPage++;
    await fetchGridViewImages(_gridViewPage);
  }

  Future<void> refresh() async {
    setState(() {
      gridViewImages.clear();
      uniqueGridViewImages.clear();
      currentApiKeyIndex = 0; // Reset API key index to use the first key after a refresh
      apiRequestSucceeded = false; // Reset API request status
    });

    await fetchGridViewImages(_gridViewPage);

    // Check if any API request succeeded
    if (!apiRequestSucceeded) {
      showLimitReachedMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: refresh,
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: pageViewImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 130,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  // Handle tap on the entire item if needed
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Handle tap on individual image
                                      print('Tapped on image at index $index');
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => catImageView(categoryImg: pageViewImages[index],categoryName: pageViewImgName[index],)),
                                      );
                                    },
                                    child: Image.network(
                                      pageViewImages[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 8.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pageViewImages.length,
                                (index) => buildIndicator(index),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: gridViewImages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == gridViewImages.length) {
                          fetchMoreGridViewImages();
                          return const Center(child: CircularProgressIndicator());
                        }

                        return InkWell(
                          onTap: () {
                            // Navigate to the second screen when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ImageView(imgUrl: gridViewImages[index % gridViewImages.length], imgName: "New Car",)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                  gridViewImages[index % gridViewImages.length],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(int index) {
    return Container(
      width: 8.0,
      height: 20.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.white : Colors.grey,
      ),
    );
  }
}