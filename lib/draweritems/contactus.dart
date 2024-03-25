import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
              'Welcome to wallpix!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'THANKS FOR CONTACTING US.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _launchGmail(context);
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

  void _launchGmail(BuildContext context) async {
    final Email email = Email(
      recipients: ['fenildabhi612000@gmail.com'], // Replace with your Gmail address
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to open email client.'),
      ));
    }
  }
}
