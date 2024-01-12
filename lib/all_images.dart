import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:walllhang/imageView.dart';

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
  List<String> pageViewImages = [];
  List<String> gridViewImages = [];
  int _currentPage = 0;

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  // Timer for auto-scrolling
  late Timer _timer;

  void startAutoScroll() {
    const Duration duration = Duration(seconds: 3);

    _timer = Timer.periodic(duration, (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          (_currentPage + 1) % pageViewImages.length,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> fetchImages() async {
    await fetchPageViewImages();
    await fetchGridViewImages();
  }

  Future<void> fetchPageViewImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=4&page=9'),
        headers: {
          'Authorization': 'a7uMZCqGxAC5qTXHdepkr02KXNfOFJtk60tIW0aeNdzBQrFJILQ4ou6S',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> photos = data['photos'];
      setState(() {
        pageViewImages =
        List<String>.from(photos.map((item) => item['src']['large'] as String));
      });
    } catch (error) {
      print('Error fetching images: $error');
    }
  }

  Future<void> fetchGridViewImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=89&page=2'),
        headers: {
          'Authorization': 'a7uMZCqGxAC5qTXHdepkr02KXNfOFJtk60tIW0aeNdzBQrFJILQ4ou6S',
        },
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> photos = data['photos'];
      setState(() {
        gridViewImages =
        List<String>.from(photos.map((item) => item['src']['large'] as String));
      });
    } catch (error) {
      print('Error fetching images: $error');
    }
  }

  Future<void> refresh() async {
    await fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Container(
          child: Column(
            children: [
              Text(
                'Wallpapers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  wordSpacing: 10,
                  height: 2,
                ),
              ),
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
                                // Handle page view item tap
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  pageViewImages[index],
                                  fit: BoxFit.cover,
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.5,
                    ),
                    itemCount: gridViewImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Handle grid view item tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => imageView()),
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
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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
