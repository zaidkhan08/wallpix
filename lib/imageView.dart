import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class imageView extends StatelessWidget {
  String imgUrl;
  imageView({super.key, required this.imgUrl});
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
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(imgUrl), fit: BoxFit.cover)),
                    width: 360,
                    height: 500,

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
