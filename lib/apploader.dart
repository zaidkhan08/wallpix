import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:walllhang/all_images.dart';
import 'package:walllhang/imggen.dart';
import 'package:walllhang/screens/auth_page.dart';

class introslider extends StatefulWidget {
  const introslider({super.key});

  @override
  State<introslider> createState() => _introsliderState();
}

class _introsliderState extends State<introslider> {

  late PageController mycontroler =PageController();
  Icon micon =  Icon(Icons.navigate_next,size: 35,);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller:mycontroler ,
            onPageChanged: (index){
              setState(() {
                if( index == 2){
                  micon = Icon(Icons.done_all_outlined);
                }
                else(
                    micon =  Icon(Icons.navigate_next,size: 35,)
                );
              });
            },

            children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assests/Screen1.png"),
                      fit: BoxFit.cover
                  )
              ),),
            Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assests/Screen2.png"),
                        fit: BoxFit.cover
                    )
                ),),
            Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assests/Screen3.png"),
                        fit: BoxFit.cover
                    )
                ),
              child:
              Center(child:
              ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context)=>AuthPage() ));
                  },
                  child: Text("Get Started"),)

            )
            )],
            ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Row(mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: (){
                        mycontroler.jumpToPage(2);
                      },
                      child: Text("Skip",style: TextStyle(fontSize: 18),)),
                  SmoothPageIndicator(
                      controller: mycontroler, count: 3),
                  GestureDetector(
                      onTap: (){
                        mycontroler.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: micon)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
