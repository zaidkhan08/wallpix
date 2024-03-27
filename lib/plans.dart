import 'package:flutter/material.dart';
import 'Widgets/subscriptionCard.dart';

class Plans extends StatefulWidget {
  const Plans({Key? key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
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
                width: 300, // Adjusted width of the card
                child: SubscriptionCard(
                  title: '₹299',
                  price: '1000 pixCoins',
                  description: 'Generate your unique ideas more efficiently.',
                  buttonText: 'BUY NOW',
                  onPressed: () {
                    // Action when the button is pressed
                  },
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300, // Adjusted width of the card
                child: SubscriptionCard(
                  title: '₹499',
                  price: '1500 pixCoins',
                  description: 'Generate your unique ideas more efficiently.',
                  buttonText: 'BUY NOW',
                  onPressed: () {
                    // Action when the button is pressed
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}