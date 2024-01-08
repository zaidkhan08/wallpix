import 'package:flutter/material.dart';

class AllImages extends StatelessWidget {
  const AllImages({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body:Container(
        height: 100,
        child: Center(child: Column(
          children: [

            Text('Wallpapers!!',style: TextStyle(color: Colors.white,fontSize: 20,wordSpacing: 10,height: 2,),),
            Text('helooo'),
          ],
        )),



      ),

    );
  }
}
