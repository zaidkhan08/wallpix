import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:walllhang/all_images.dart';
import 'package:walllhang/fav.dart';
import 'package:walllhang/home.dart';

import 'categoryView.dart';
import 'imageView.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'wallpix',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(title: 'The Wallpapers App!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final pages =[AllImages(),Home(),categoryView()];
final pageController = PageController(initialPage: 2);
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

          title: Container(
            height: 100,
            padding: EdgeInsets.only(top: 30,bottom: 24),
            child: TextField(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => imageView()),
                );
              },
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.transparent, // Set the cursor color to transparent
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white24,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.transparent), // Set border color when focused
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: IconButton(
                  icon: Icon(Icons.search,color: Colors.white54,),
                  onPressed: () {
                    // Handle search logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => imageView()),
                    );
                  },

                ),
              ),


            ),
          ),



          backgroundColor: Colors.black,




          ),


        bottomNavigationBar: CurvedNavigationBar(

          height: 59,
          backgroundColor: Colors.transparent,
          color: Colors.white,

          items: [
            Icon(Icons.home,size: 30,),
            Icon(Icons.category_outlined,size: 30,),
            Icon(Icons.person,size: 30,),

          ],
          onTap: (int index){
            setState(() {
              currentSelected = index;
              pageController.jumpToPage(currentSelected);
            });
          },


        ),






        body: PageView.builder(
            controller: pageController,
            onPageChanged: (int index) {
              // Update the selected index when the page changes
              setState(() {
                currentSelected = index;
              });
            },
            itemCount: pages.length,
            itemBuilder:(BuildContext context,int index){
              return pages[index];
            },


            ),
        );
  }
}