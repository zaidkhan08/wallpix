import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget imageCard() => Container(
  width: 300,
  height: 450,
  child: Container(
    padding: EdgeInsets.only(left: 8, top: 20),
    child: Column(

      children: [
        ClipRRect(
          child: Image.network(
            "https://images.unsplash.com/photo-1555353540-64580b51c258?q=80&w=1956&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            width: 300,
            height: 450,
            fit: BoxFit.cover,

          ),
          borderRadius: BorderRadius.circular(8),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                      "Car01",
                    style: TextStyle(
                      color: Colors.white,
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
              ),
            ],
          ),
        )
      ],
    ),
  ),
);