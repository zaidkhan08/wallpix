import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// LikedImagesScreen widget
class LikedImagesScreen extends StatelessWidget {
  final List<String> likedImageUrls;

  const LikedImagesScreen({Key? key, required this.likedImageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Images'),
      ),
      body: ListView.builder(
        itemCount: likedImageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                likedImageUrls[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ImageView widget
class ImageView extends StatefulWidget {
  final String imgUrl;
  final String imgName;

  const ImageView({Key? key, required this.imgUrl, required this.imgName}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late Future<List<String>> _futureImages;
  List<String> _likedImageUrls = [];

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

  void _toggleLike(String imageUrl) {
    setState(() {
      if (_likedImageUrls.contains(imageUrl)) {
        _likedImageUrls.remove(imageUrl);
      } else {
        _likedImageUrls.add(imageUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InteractiveViewer(
                      scaleEnabled: true, // Enable scaling
                      child: ClipRRect(
                        child: Image.network(
                          widget.imgUrl,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      boundaryMargin: EdgeInsets.all(20),
                      minScale: 0.1,
                      maxScale: 4.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200, // Adjust width as needed
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your button functionality here
                        },
                        child: Text('Apply'),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _toggleLike(widget.imgUrl);
                      },
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Icon(
                          _likedImageUrls.contains(widget.imgUrl) ? Icons.favorite : Icons.favorite_border,
                          color: _likedImageUrls.contains(widget.imgUrl) ? Colors.red : Colors.white,
                          size: 32,
                          key: UniqueKey(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LikedImagesScreen(likedImageUrls: _likedImageUrls),
            ),
          );
        },
        child: Icon(Icons.favorite),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageView(
      imgUrl: 'https://via.placeholder.com/300', // Initial image URL
      imgName: 'Sample Image', // Initial image name
    ),
  ));
}
