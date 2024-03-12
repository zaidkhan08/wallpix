import 'package:flutter/material.dart';
import 'package:walllhang/screens/auth_page.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:walllhang/all_images.dart';
// import 'package:walllhang/api/rest.dart';
// import 'package:walllhang/fav.dart';
// import 'package:walllhang/home.dart';
// import 'package:walllhang/login.dart';
// import 'package:walllhang/profilepage/profile.dart';
// import 'searchbar.dart';
// import 'imageView.dart';
import 'imggen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: AuthPage()
      //MyHomePage(title: 'The Wallpapers App!'),
    );
  }
}