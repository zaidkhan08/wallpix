import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walllhang/all_images.dart';
import 'package:walllhang/apploader.dart';
import 'package:walllhang/draweritems/contactus.dart';
import 'package:walllhang/home.dart';
import 'package:walllhang/login.dart';
import 'package:walllhang/plans.dart';
import 'package:walllhang/profilepage/profile.dart';
import 'package:walllhang/report.dart';
import 'package:walllhang/screens/favoriteImagesView.dart';
import 'searchbar.dart';
import 'imggen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> pages = [AllImages(), Home(), AIApp()];
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  bool _isDrawerOpen = false;
  bool _isSearchOpen = false;
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }

  String extractUsername(String email) {
    return email.substring(0, email.indexOf('@'));
  }

  void _openDrawer() {
    setState(() {
      _isDrawerOpen = true;
    });
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Stack(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      extractUsername(user.email!),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  accountEmail: Text(user.email!),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1552250575-e508473b090f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Text(
                    '-Welcome to Wallpix',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: const Text(
                      'Log out',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      signUserOut();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.contacts),
                    title: const Text(
                      'Contact us',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Gmail()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_rounded),
                    title: const Text(
                      'Favorites',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => favoriteImagesView()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.share_sharp),
                    title: const Text(
                      'Share',
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.report),
                    title: const Text(
                      'Report',
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Report(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {
      setState(() {
        _isDrawerOpen = false;
      });
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
    });
  }

  void _navigateToSearchPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Search(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
        title: currentIndex != 2
        ? AnimatedCrossFade(
        firstChild: const Text(
        'Wallpix',
        style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        wordSpacing: 10,
        height: 2,
    ),
    ),
    secondChild: Container(
    width: 200,
    child: TextField(
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    hintText: 'Search...',
    hintStyle: TextStyle(color: Colors.grey),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(
    color: Colors.white,
    ),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    ),
    ),
    ),
    crossFadeState: _isSearchOpen
    ? CrossFadeState.showSecond
        : CrossFadeState.showFirst,
    duration: Duration(milliseconds: 300),
    )
        : null,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.white),
    actions: [
    IconButton(
    icon: Icon(_isSearchOpen ? Icons.close : Icons.search_outlined),
    onPressed: _isSearchOpen ? _toggleSearch : _navigateToSearchPage,
    ),
    IconButton(
    icon: Icon(_isDrawerOpen ? Icons.close : Icons.menu),
    onPressed: _openDrawer,
    ),
    ],
    ),
    body: IndexedStack(
    index: currentIndex,
    children: pages,
    ),
    bottomNavigationBar: CurvedNavigationBar(
    height: 50,
    backgroundColor: Colors.white10,
    color: Colors.black54,
    items: [
    Icon(Icons.home, size: 30, color: Colors.white),
    Icon(Icons.category_outlined, size: 30, color: Colors.white),
    Icon(Icons.memory, size: 30, color: Colors.white),
    ],
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
    ),
    );
  }
}
