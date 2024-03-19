import 'package:flutter/material.dart';
import 'package:walllhang/categoryImageView.dart';
import 'package:walllhang/Widgets/categoryBlock.dart';
import 'package:walllhang/api/apiOperations.dart';
import 'package:walllhang/Models/categoryModels.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _AllImagesState createState() => _AllImagesState();
}

class _AllImagesState extends State<Home> {
  late List<CategoryModel> CatModList;
  bool isLoading = true;
  PageController _pageController = PageController();
  List<String> images = [
    "https://picsum.photos/seed/picsum/200/300",
    "https://picsum.photos/208/300",
    "https://picsum.photos/202/300",
    "https://picsum.photos/204/300",

  ];

  GetCatDetails() async {
    CatModList = await apiOperations.getCategoriesList();
    setState(() {
      isLoading = false;
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
          children: [
            Container(
              height: 130,
              padding: const EdgeInsets.only(top: 4 ,left: 8,right: 8),
              child: SizedBox(
                height: 60,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.white70,
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
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
            const SizedBox(height: 25,),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        MaterialPageRoute(builder: (context) => catImageView(categoryImg: CatModList[index].catImgUrl,categoryName: CatModList[index].catName,)),
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
      );
    }

  Widget buildIndicator(int index) {
    return Container(
        width: 8.0,
        height: 20.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.grey,
            ),
        );
    }
}