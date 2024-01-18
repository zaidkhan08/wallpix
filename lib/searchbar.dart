import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _focusNode.requestFocus();
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          focusNode: _focusNode,
          style: TextStyle(color: Colors.blue),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white38),
            contentPadding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 8),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.white54,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small containers
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: List.generate(
                4, // Replace with the number of containers you want
                    (index) => Container(
                  width: 110,
                  height: 40,
                  margin: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey, // Customize the color as needed
                    borderRadius: BorderRadius.circular(12), // Customize the border radius
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Search(),
  ));
}
