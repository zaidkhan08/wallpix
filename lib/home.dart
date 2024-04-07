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

  // List of colors
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
    const Color(0xFFFFD700),
    // Orange
    const Color(0xFFFF7F11),
    // Teal
    const Color(0xFF00F5E0),
    // Violet/Purple
    const Color(0xFF6A0572),
    // Peach
    const Color(0xFFF9CBA9),
  ];

  // List of gradient colors corresponding to the colors
  List<Color> gradientColors = [
    // Black gradient
    const Color(0xFF423C3E),
    // White gradient
    const Color(0xFFECECEC),
    // Red gradient
    const Color(0xFFD20A00),
    // Blue gradient
    const Color(0xFF0067CB),
    // Green gradient
    const Color(0xFF058C4E),
    // Yellow gradient
    const Color(0xFFFFECA8),
    // Orange gradient
    const Color(0xFFFF9741),
    // Teal gradient
    const Color(0xFF00B9A9),
    // Violet/Purple gradient
    const Color(0xFF881F91),
    // Peach gradient
    const Color(0xFFFFC695),
  ];


  List<String> colorNames = ['Black','White','Red', 'Blue', 'Green', 'Yellow', 'Orange', 'Teal', 'Purple', 'Peach'];
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
    'https://images.unsplash.com/photo-1601370690183-1c7796ecec61?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Yellow
    'https://images.unsplash.com/flagged/photo-1593005510329-8a4035a7238f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Orange
    'https://images.unsplash.com/photo-1530982011887-3cc11cc85693?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Teal gradient
    'https://images.unsplash.com/photo-1564352969906-8b7f46ba4b8b?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Violet/Purple gradient
    'https://images.unsplash.com/photo-1575318080244-dd217d9db1e2?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    // Peach gradient
    'https://images.unsplash.com/photo-1546448396-6aef80193ceb?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
                                  gradient: RadialGradient(
                                    colors:[colors[index], gradientColors[index]],
                                    radius: 0.75
                                  ),
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