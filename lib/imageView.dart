import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String imgName;

  const ImageView({Key? key, required this.imgUrl, required this.imgName}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late Future<List<String>> _futureImages;
  late String _currentTime;
  late String _currentDay;
  bool _isLiked = false;
  bool _isHoldingImage = false;

  @override
  void initState() {
    super.initState();
    _futureImages = fetchImagesFromAPI();
    _updateTime();
    _updateDay();
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

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added to favorites'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green[600],
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red[600],
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
            ),
          ),
        );
      }
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime = DateFormat('hh:mm a').format(DateTime.now());
    });
    Future.delayed(Duration(minutes: 1) - Duration(seconds: DateTime.now().second), () {
      _updateTime();
    });
  }

  void _updateDay() {
    setState(() {
      _currentDay = DateFormat('EEEE, d, MMMM').format(DateTime.now());
    });
    Future.delayed(Duration(minutes: 1), () {
      _updateDay();
    });
  }

  Future<void> setWallpaper(int location) async {
    String url = widget.imgUrl;
    var file = await DefaultCacheManager().getSingleFile(url);

    bool success = await WallpaperManager.setWallpaperFromFile(file.path, location);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wallpaper applied successfully'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply wallpaper'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressStart: (_) {
          setState(() {
            _isHoldingImage = true;
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            _isHoldingImage = false;
          });
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            scaleEnabled: true,
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
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            child: Visibility(
                              visible: !_isHoldingImage,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 87), // Add padding
                                child: Column(
                                  children: [
                                    Text(
                                      _currentTime,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 48, // Increase font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 4), // Add spacing
                                    Text(
                                      _currentDay,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18, // Day font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
              child: Visibility(
                visible: !_isHoldingImage,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Set Wallpaper'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Select the location to set the wallpaper:'),
                                          ElevatedButton(
                                            onPressed: () {
                                              setWallpaper(WallpaperManager.HOME_SCREEN);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Home Screen'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setWallpaper(WallpaperManager.LOCK_SCREEN);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Lock Screen'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setWallpaper(WallpaperManager.HOME_SCREEN);
                                              setWallpaper(WallpaperManager.LOCK_SCREEN);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Both Screens'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text('Apply'),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: _toggleLike,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.white,
                              size: 38,
                              key: UniqueKey(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
