import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Widgets/imageViewCard.dart';

class imageView2 extends StatelessWidget {
  const imageView2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          separatorBuilder: (context, _) => SizedBox(width: 12,),
          itemBuilder: (context, index) => imageCard(),
        ),
      ),
    );
  }
}
