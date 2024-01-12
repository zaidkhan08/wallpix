import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class imageView extends StatelessWidget {
  const imageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 70),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  child: Image.network(
                    "https://images.unsplash.com/photo-1555353540-64580b51c258?q=80&w=1956&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    width: 360,
                    height: 500,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Car01",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: (){},
                        child: Icon(
                          CupertinoIcons.heart,
                          color: Colors.white,
                        )
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: (){},
                      child: Text("Apply"),
                      style: ButtonStyle(

                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    "Recommended",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
