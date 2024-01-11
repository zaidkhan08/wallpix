import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<Home> {
  PageController _pageController = PageController();
  List<String> images = [
    "https://picsum.photos/seed/picsum/200/300",
    "https://picsum.photos/208/300",
    "https://picsum.photos/202/300",
    "https://picsum.photos/204/300",

  ];

  List<String> gridViewImages = [
  "https://picsum.photos/300/201",
  "https://picsum.photos/300/202",
  "https://picsum.photos/300/203",
  "https://picsum.photos/300/204",
    "https://picsum.photos/300/205",
    "https://picsum.photos/300/206",
    "https://picsum.photos/300/207",
    "https://picsum.photos/300/208",

  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            Text(
              '- - - -  Select Your Favourite Catagory  - - - -',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                wordSpacing: 10,
                height: 2,
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: gridViewImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(gridViewImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
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