import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:walllhang/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await dotenv.load(fileName: ".env");
  Stripe.publishableKey = 'pk_test_51P0iXPSBCE40NrRgJ3N8qfhhBmGKfz8EdWkJla2S7zG3rf0Yfo7rXbeQ4NSGdzvlqIt97vnN3FZvaRbDBIHdI9BZ00aPmckDOg';
  //dotenv.env["STRIPE_PUBLISH_KEY"]!;
  await Stripe.instance.applySettings();
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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for splash screen (replace with your actual loading process)
    Future.delayed(const Duration(seconds: 2), () {
      // After the delay, navigate to the authentication page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Image.asset(
          'lib/images/start.gif',
          fit: BoxFit.contain, // Adjust to fit within the screen bounds
          width: MediaQuery.of(context).size.width * 30, // Adjust width as needed
          height: MediaQuery.of(context).size.height * 30, // Adjust height as needed
        ),
      ),
    );
  }
}
