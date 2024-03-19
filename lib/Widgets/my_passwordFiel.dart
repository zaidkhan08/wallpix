import 'package:flutter/material.dart';


class passwordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const passwordField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  _passwordFieldState createState() => _passwordFieldState();
}

class _passwordFieldState extends State<passwordField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: !passwordVisible,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
            child: Icon(
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}