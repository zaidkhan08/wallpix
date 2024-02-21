import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:walllhang/all_images.dart';
import 'package:walllhang/api/rest.dart';
import 'package:walllhang/fav.dart';
import 'package:walllhang/home.dart';
import 'package:walllhang/profilepage/profile.dart';
import 'searchbar.dart';
import 'imageView.dart';
import 'imggen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'wallpix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'The Wallpapers App!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pages = [AllImages(), Home(), ai()];
  final pageController = PageController(initialPage: 0);
  int currentSelected = 0;

  @override
  void initState() {
    super.initState();

    // Add listener to the PageController to update the selected index
    pageController.addListener(() {
      int currentIndex = pageController.page?.round() ?? 0;
      if (currentIndex != currentSelected) {
        setState(() {
          currentSelected = currentIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: currentSelected != 2
            ? Container(
          height: 100,
          padding: EdgeInsets.only(top: 30, bottom: 24),
          child: Row(
            children: [
              Text(
                'Wallpixx',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  wordSpacing: 10,
                  height: 2,
                ),
              ),
              Spacer(), // Add spacer to push icons to the right
              IconButton(
                icon: Icon(Icons.search_outlined, color: Colors.white),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search()),
                  );
                },
              ),
              Transform.scale(
                scale: 1.5,
                child: IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                    // Add the action when the profile icon is tapped
                  },
                ),
              ),
            ],
          ),
        )
            : null,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // The PageView
          Positioned.fill(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (int index) {
                // Update the selected index when the page changes
                setState(() {
                  currentSelected = index;
                });
              },
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int index) {
                return pages[index];
              },
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          // The CurvedNavigationBar on top
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CurvedNavigationBar(
              height: 59,
              backgroundColor: Colors.transparent,
              color: Colors.black54,
              items: [
                Icon(Icons.home, size: 30,color: Colors.white,),
                Icon(Icons.category_outlined, size: 30,color: Colors.white,),
                Icon(Icons.memory, size: 30,color: Colors.white,),
              ],
              onTap: (int index) {
                setState(() {
                  currentSelected = index;
                  pageController.jumpToPage(currentSelected);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
