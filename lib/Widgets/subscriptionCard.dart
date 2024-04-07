import 'dart:async';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatefulWidget {
  final String title;
  final String price;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  const SubscriptionCard({
    required this.title,
    required this.price,
    required this.description,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  _SubscriptionCardState createState() => _SubscriptionCardState();

}

class _SubscriptionCardState extends State<SubscriptionCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the timer to stop the animation after 7 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Cancel the timer
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320, // Adjusted height to accommodate content
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: child,
                );
              },
              child: Container(
                width: 300, // Adjusted width of the card
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 60,
                      width: 60,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: Icon(
                          Icons.star,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 200, // Adjusted width of the button
                      child: ElevatedButton(
                        onPressed: widget.onPressed,
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                        ),
                        child: Text(
                          widget.buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}