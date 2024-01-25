import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:walllhang/homebtn/floral.dart';
import 'package:walllhang/homebtn/luxury.dart';
import 'package:walllhang/homebtn/nature.dart';
import 'package:walllhang/homebtn/visual.dart';

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

    // Start auto-scrolling after fetching images
    startAutoScroll();
  }

  Future<void> fetchPageViewImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=4'),
        headers: {
          'Authorization': 'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA',
        },
      );

      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        pageViewImages = List<String>.from(data.map((item) => item['urls']['regular'] as String));
      });
    } catch (error) {
      print('Error fetching page view images: $error');
    }
  }

  Future<void> fetchGridViewImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.unsplash.com/photos/random?count=60'),
        headers: {
          'Authorization': 'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA',
        },
      );

      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        gridViewImages = List<String>.from(data.map((item) => item['urls']['regular'] as String));
      });
    } catch (error) {
      print('Error fetching grid view images: $error');
    }
  }

  Future<void> refresh() async {
    await fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          // Close the keyboard when tapping on the screen
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
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
                SizedBox(
                  height: 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Floral(),
                              ),
                            );
                            // Handle button 1 tap
                            print('Button 1 tapped');
                          },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white24),),
                          child: Text('floral',style: TextStyle(color: Colors.white),),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Visual(),
                              ),
                            );
                            // Handle button 2 tap
                            print('Button 2 tapped');
                          },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white24),),
                          child: Text('visual',style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Nature(),
                              ),
                            );
                            // Handle button 3 tap
                            print('Button 3 tapped');
                          },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white24),),
                          child: Text('Nature',style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Luxury(),
                              ),
                            );
                            // Handle button 4 tap
                            print('Button 4 tapped');
                          },
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white24),),
                          child: Text('Luxury',style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
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
                            // Navigate to the second screen when tapped
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => imageView()),
                            // );
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
