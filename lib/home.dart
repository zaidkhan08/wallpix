import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:walllhang/categoryView.dart';
import 'package:walllhang/screens/categoryBlock.dart';
import 'package:walllhang/api/apiOperations.dart';
import 'package:walllhang/Models/categoryModels.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<Home> {
  late List<CategoryModel> CatModList;
  PageController _pageController = PageController();
  List<String> images = [
    "https://picsum.photos/seed/picsum/200/300",
    "https://picsum.photos/208/300",
    "https://picsum.photos/202/300",
    "https://picsum.photos/204/300",

  ];

  GetCatDetails() async {
    CatModList = await apiOperations.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(CatModList);
    setState(() {
      CatModList = CatModList;
    });
  }

  // List<String> gridViewImages = [
  // "https://picsum.photos/300/201",
  // "https://picsum.photos/300/202",
  // "https://picsum.photos/300/203",
  // "https://picsum.photos/300/204",
  //   "https://picsum.photos/300/205",
  //   "https://picsum.photos/300/206",
  //   "https://picsum.photos/300/207",
  //   "https://picsum.photos/300/208",
  //   "https://picsum.photos/300/209",
  //
  // ];

  int _currentPage = 0;

  @override
  void initState(){
    super.initState();
    GetCatDetails();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [

            Container(
              height: 130,
              padding: EdgeInsets.only(top: 4 ,left: 8,right: 8),
              child: Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white70,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Select your Favorite Category",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white70,
                      )
                  )
                ],
              ),
            ),
            SizedBox(height: 25,),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: CatModList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      print("Tap");
                      // Go to Second Screen .. currently NOT Working
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => catView(categoryImg: CatModList[index].catImgUrl,categoryName: CatModList[index].catName,)),
                      );
                    },
                    child: catBlock(
                      categoryImgSrc: CatModList[index].catImgUrl,
                      categoryName: CatModList[index].catName,
                    ),
                  );
                }
             ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildIndicator(int index) {
    return Container(
        width: 8.0,
        height: 20.0,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.grey,
            ),
        );
    }
}