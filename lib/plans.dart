import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:walllhang/utils/userRepo.dart';
import 'Widgets/subscriptionCard.dart';
import 'package:http/http.dart' as http;

class Plans extends StatefulWidget {
  const Plans({Key? key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  final _userRepo = UserRepo(FirebaseFirestore.instance);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? paymentIntentData;
  String userId = "";

  void initState() {
    super.initState();

    getUserId().then((value) {
      if (value != null) {
        setState(() {
          userId = value;
        });
      }
    });
  }

  Future<String?> getUserId() async {
    User? user = _auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      print('No user is currently signed in');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plans'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 400, // Adjusted width of the card
                height: 320,
                child: SubscriptionCard(
                  title: '₹299',
                  price: '500 pixCoins',
                  description: 'Generate your unique ideas more efficiently.',
                  buttonText: 'BUY NOW',
                  onPressed: () async {
                    // Action when the button is pressed
                    await initPaymentSheet("299", "inr");
                    try {
                      await Stripe.instance.presentPaymentSheet();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Payment Successful',
                              style: TextStyle(color: Colors.white)),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green[600],
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      try {
                        _userRepo.addCoins(userId, 500);
                        print("500 Coins added!");
                        Navigator.pop(context);
                      } catch (e) {
                        print("Coins not added! $e");
                      }
                    } catch (e) {
                      print("Payment Sheet Failed");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Payment Failed',
                            style: TextStyle(color: Colors.white)),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red[600],
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ),
              //const SizedBox(height: 20),
              SizedBox(
                width: 400, // Adjusted width of the card
                height: 320,
                child: SubscriptionCard(
                  title: '₹499',
                  price: '1000 pixCoins',
                  description: 'Create even more stunning wallpapers.',
                  buttonText: 'BUY NOW',
                  onPressed: () async {
                    // Action when the button is pressed
                    await initPaymentSheet("499", "inr");
                    try {
                      await Stripe.instance.presentPaymentSheet();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Payment Successful',
                              style: TextStyle(color: Colors.white)),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green[600],
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      try {
                        _userRepo.addCoins(userId, 1000);
                        print("1000 Coins added!");
                        Navigator.pop(context);
                      } catch (e) {
                        print("Coins not added! $e");
                      }
                    } catch (e) {
                      print("Payment Sheet Failed");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Payment Failed',
                              style: TextStyle(color: Colors.white)),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red[600],
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
      final secretKey =
          'sk_test_51P0iXPSBCE40NrRgVyVye1AP64VyNB1eID9WcVhC7CWn4Dud30LoZCpje0svQLd76mvgJeiLI5OZ2cDbz7HCcjcx0006BteSxc';
      // dotenv.env['STRIPE_SECRET_KEY']!;
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency.toLowerCase(),
        //'automatic_payment_methods[enabled]': 'true',
        'payment_method_types[]': 'card',
        'description': "Buy PixCoins",
        'shipping[name]': 'Zack',
        'shipping[address][line1]': '510 Townsend St',
        'shipping[address][postal_code]': '90089',
        'shipping[address][city]': 'Los Angeles',
        'shipping[address][state]': 'CA',
        'shipping[address][country]': 'US',
      };

      final response = await http.post(url,
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body.toString());
        print(json);
        return json;
      } else {
        print('Error in calling Payment Intent');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> initPaymentSheet(String amount, String currency) async {
    try {
      // 1. create payment intent on the server
      final paymentData = await createPaymentIntent(amount, currency);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'WallPix',
          paymentIntentClientSecret: paymentData['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: paymentData!['ephemeralKey'],
          customerId: paymentData['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      print('Error: $e');
      rethrow;
    }
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }
}
