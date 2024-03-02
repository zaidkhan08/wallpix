import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Gmail extends StatelessWidget {
  const Gmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Gmail!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'You can add your text here.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _launchGmail();
              },
              icon: Image.asset(
                'lib/images/google.png', // Provide your Gmail logo image path here
                width: 32,
                height: 32,
              ),
              label: Text(
                'Continue with Gmail',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchGmail() async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'idhackkaregabhadk@gmail.com', // Replace with your Gmail address
    );

    String url = _emailLaunchUri.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Gmail';
    }
  }
}
