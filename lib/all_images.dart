import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'home.dart';
import 'imageView.dart';

class AllImages extends StatefulWidget {
  AllImages({Key? key}) : super(key: key);

  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  PageController _pageController = PageController();
  List<String> pageViewImages = [
    "https://picsum.photos/seed/picsum/200/300",
    "https://picsum.photos/208/300",
    "https://picsum.photos/202/300",
    "https://picsum.photos/204/300",
  ];
  List<String> gridViewImages = [
    "https://picsum.photos/300/208",
    "https://picsum.photos/300/202",
    "https://picsum.photos/300/204",
    "https://picsum.photos/300/201",
    "https://picsum.photos/300/203",
    "https://picsum.photos/300/205",
    "https://picsum.photos/300/206",
    "https://picsum.photos/300/207",
    "https://picsum.photos/300/209",
    "https://picsum.photos/300/210",
    "https://picsum.photos/300/211",
    "https://picsum.photos/300/212",
    "https://picsum.photos/300/213",
    "https://picsum.photos/300/214",
    "https://picsum.photos/300/215",
    "https://picsum.photos/300/216",
    "https://picsum.photos/300/217",
    "https://picsum.photos/300/218",
  ];
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
  }

  @override
  void dispose() {
    // Dispose of the PageController and cancel the timer
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
        // Check if the page controller has clients before animating to the next page
        _pageController.animateToPage(
          (_currentPage + 1) % pageViewImages.length,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => imageView()),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  pageViewImages[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ));
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(gridViewImages[index]),
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