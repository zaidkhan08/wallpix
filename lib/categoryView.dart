import 'package:flutter/material.dart';

class catView extends StatelessWidget {
  final String categoryImg;
  final String categoryName;
  const catView({super.key, required this.categoryImg, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30,),
              Stack(
                children: [
                  Image.network(
                    categoryImg,
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black38,
                  ),
                  Center(
                      child: Column(
                        children: [
                          SizedBox(height: 35,),
                          Text(
                            "Category",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            categoryName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 300,
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 30,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: ((context, index) => GridTile(
                      child: InkWell(
                        onTap: (){},
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              "https://images.unsplash.com/photo-1514316454349-750a7fd3da3a?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              height: 500,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.teal,
                          ),
                          height: 500,
                          width: 50,
                        ),
                      ),
                  )
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