import 'package:flutter/material.dart';

class button_tile extends StatelessWidget {
  final String imagePath;
  final String text;
  final Function() onTap;

  const button_tile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 20,
              ),
              const SizedBox(width: 20,),
              Text(text,  style: TextStyle(color: Colors.grey[700]),)
            ],
          ),
        ),
      ),
    );
  }
}
