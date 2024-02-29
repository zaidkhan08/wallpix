import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String imgName;

  const ImageView({Key? key, required this.imgUrl, required this.imgName}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late Future<List<String>> _futureImages;

  @override
  void initState() {
    super.initState();
    _futureImages = fetchImagesFromAPI();
  }

  Future<List<String>> fetchImagesFromAPI() async {
    // Fetch images from Unsplash API
    final response = await http.get(Uri.parse('https://api.unsplash.com/photos/random?count=6'), headers: {
      'Authorization': '5P052_ckCJv-rt9Sfb71Y_U6KqhEVG6JZufL8338wk4',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<String> imageUrls = [];
      for (var item in data) {
        if (item['urls'] != null && item['urls']['regular'] != null) {
          imageUrls.add(item['urls']['regular']);
        }
      }
      return imageUrls;
    } else {
      throw Exception('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.only(top: 70),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.imgUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 360,
                    height: 500,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          widget.imgName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        CupertinoIcons.heart,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Apply"),
                      style: ButtonStyle(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Recommended",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<List<String>>(
                future: _futureImages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          snapshot.data![index],
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  } else {
                    return Text('No data');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
