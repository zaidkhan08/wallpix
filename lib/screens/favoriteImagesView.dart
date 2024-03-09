import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class favoriteImagesView extends StatefulWidget {
  const favoriteImagesView({super.key});

  @override
  State<favoriteImagesView> createState() => _favoriteImagesViewState();
}

class _favoriteImagesViewState extends State<favoriteImagesView> {
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection("favorites").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Favorite Images Url:"),
          Container(
            height: 250,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
              stream: users,
              builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot
              ) {
                if (snapshot.hasError){
                  return Text("Something went Wrong!");
                }

                if (snapshot.connectionState == ConnectionState.waiting){
                  return Text("Loading..");
                }

                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index){
                    return Text("ImgUrl: ${data.docs[index]['imgUrl']}");
                  },
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
