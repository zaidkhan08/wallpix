import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../imageView.dart';

class favoriteImagesView extends StatefulWidget {
  const favoriteImagesView({super.key});

  @override
  State<favoriteImagesView> createState() => _favoriteImagesViewState();
}

class _favoriteImagesViewState extends State<favoriteImagesView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userId = "";
  late final Stream<QuerySnapshot> users;

  @override
  void initState() {
    super.initState();
    getUserId().then((value) {
      if (value != null) {
        setState(() {
          userId = value;
          users = FirebaseFirestore.instance.collection("favorites").where('userId', isEqualTo: userId).snapshots();
        });
      }
    });
  }

  // get user ID of the user
  Future<String?> getUserId() async {
    User? user = _auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      print('No user is currently signed in');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,), onTap: (){ Navigator.pop(context); },),
        centerTitle: true,
        title: const Text("Favorite Images",style: TextStyle(color: Colors.white),),
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // ListView.builder(
          // itemCount: data.size,
          //   itemBuilder: (context, index){
          //     return Text("ImgUrl: ${data.docs[index]['imgUrl']}");
          //   },
          // ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: StreamBuilder<QuerySnapshot>(
                stream: users,
                builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot
                ) {
                  if (snapshot.hasError){
                    return const Text("Something went Wrong!");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.data!.size == 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: Text("No favorite images yet!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), )),
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          } ,
                          child: Container(
                              padding: const EdgeInsets.all(25),
                              margin: const EdgeInsets.symmetric(horizontal: 25),
                              decoration: BoxDecoration(
                              color: const Color(0xff088FBC),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: const Center(
                              child: Text(
                                "Add Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            ),
                            ),
                          ),
                        )
                      ],
                    );
                  }

                  final data = snapshot.requireData;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            // Navigate to the second screen when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ImageView(imgUrl: data.docs[index]['imgUrl'], imgName: "Image",)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: NetworkImage(data.docs[index]['imgUrl']), // Remove quotes here
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
