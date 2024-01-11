import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Widgets/imageViewCard.dart';

class imageView extends StatelessWidget {
  const imageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          separatorBuilder: (context, _) => SizedBox(width: 12,),
          itemBuilder: (context, index) => imageCard(),
        ),
      ),
    );
  }
}
