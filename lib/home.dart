import 'package:flutter/material.dart';
import 'package:walllhang/categoryImageView.dart';
import 'package:walllhang/Widgets/categoryBlock.dart';
import 'package:walllhang/api/apiOperations.dart';
import 'package:walllhang/Models/categoryModels.dart';
import 'package:walllhang/imageView.dart';

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

  List<Color> colors = [
    // Black
    const Color(0xFF2E282A),
    // White
    const Color(0xFFFEFCFB),
    // Red
    const Color(0xFFE70E02),
    // Blue
    const Color(0xFF084887),
    // Green
    const Color(0xFF137547),
    // Yellow
    const Color(0xFFECC30B),
    //Orange
    const Color(0xFFFF7F11)
  ];

  List<String> colorNames = ['Black','White','Red', 'Blue', 'Green', 'Yellow', 'Orange'];
  List<String> colorUrl = [
    // Black
    'https://images.unsplash.com/photo-1650954316166-c3361fefcc87?q=80&w=2127&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // White
    'https://images.unsplash.com/photo-1519120944692-1a8d8cfc107f?q=80&w=1936&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Red
    'https://images.unsplash.com/flagged/photo-1593005510509-d05b264f1c9c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Blue
    'https://images.unsplash.com/photo-1589859762194-eaae75c61f64?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Green
    'https://images.unsplash.com/photo-1601370690183-1c7796ecec61?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    // Yellow
    'https://images.unsplash.com/flagged/photo-1593005510329-8a4035a7238f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
    // Orange
    'https://images.unsplash.com/photo-1530982011887-3cc11cc85693?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];

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
            // Container(
            //   height: 130,
            //   padding: const EdgeInsets.only(top: 4 ,left: 8,right: 8),
            //   child: SizedBox(
            //     height: 60,
            //     child: GridView.builder(
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 4,
            //         crossAxisSpacing: 8.0,
            //         mainAxisSpacing: 8.0,
            //       ),
            //       itemCount: images.length,
            //       itemBuilder: (context, index) {
            //         return Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(10.0),
            //             image: DecorationImage(
            //               image: NetworkImage(images[index]),
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            // ),

            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.only(top: 12,left: 12.0, right: 12),
                child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to catImageView
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => catImageView(categoryImg: colorUrl[index], categoryName: colorNames[index])
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: [
                              // Color Container
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  borderRadius: BorderRadius.circular(16),
                                ),

                                // if you want to show text inside container

                                // child: Center(
                                //   child: Text(
                                //     colorNames[index],
                                //     style: const TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 12,
                                //         fontWeight: FontWeight.bold
                                //     ),
                                //   ),
                                // ),
                              ),

                              // if you want to show text below container

                              // Center(
                              //   child: Text(
                              //     colorNames[index],
                              //     style: const TextStyle(
                              //         color: Colors.white,
                              //         fontSize: 12,
                              //         fontWeight: FontWeight.bold
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
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