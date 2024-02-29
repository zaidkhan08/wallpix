import 'package:flutter/material.dart';
import 'package:walllhang/categoryView.dart';

class catBlock extends StatelessWidget {
  String categoryName;
  String categoryImgSrc;
  catBlock({super.key, required this.categoryImgSrc, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                categoryImgSrc,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black26
              ),
            ),
            Positioned(
              child: Center(
                child: Text(
                    categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
}
