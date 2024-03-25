import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var userId = 'abc';
  var imageUrl = '';

  @override
  void initState() {
    super.initState();
    _futureImages = fetchImagesFromAPI();
    _updateTime();
    _updateDay();

    getUserId().then((userId) {
      if (userId != null) {
        isFavoriteImage(userId, widget.imgUrl).then((value) {
          setState(() {
            _isLiked = value;
          });
        });
      }
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> getUserId() async {
    User? user = _auth.currentUser;

    if (user != null) {
      return user.uid;
    } else {
      print('No user is currently signed in');
      return null;
    }
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

  CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');

  // remove/delete favorite wallpaper from Firebase: FireStore
  Future<void> deleteDocument({required String userId, required String imageUrl}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .where('imgUrl', isEqualTo: imageUrl)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot doc in querySnapshot.docs) {
        DocumentReference docRef = doc.reference;
        await docRef.delete();
        print('Document deleted');
      }
    } else {
      print('Documents not found');
    }
  }

  Future<bool> isFavoriteImage(String userId, String imageUrl) async {
    final querySnapshot = await favorites
        .where('userId', isEqualTo: userId)
        .where('imgUrl', isEqualTo: imageUrl)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // add favorite wallpaper to Firebase: FireStore
  Future<void> addUserToFavorites({required String userId, required String imageUrl}) async {
    try {
      await favorites.add({'userId': userId, 'imgUrl': imageUrl});
      print('User is added to the Collection');
    } catch (error) {
      print('Failed to add user: $error');
    }
  }

  Future<void> _toggleLike() async {
    imageUrl = widget.imgUrl;
    String? userId = await getUserId();

    if (userId != null) {
      _isLiked = await isFavoriteImage(userId, imageUrl);
      setState(() {
        _isLiked = !_isLiked;
      });

      if (_isLiked) {
        try {
          await addUserToFavorites(userId: userId, imageUrl: imageUrl);
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
        } catch (error) {
          print('Failed to add favorite image: $error');
        }
      } else {
        try {
          await deleteDocument(userId: userId, imageUrl: imageUrl);
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
        } catch (error) {
          print('Failed to remove favorite image: $error');
        }
      }
    }
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

  Future<void> setWallpaperHome() async {
    String url = widget.imgUrl;
    int location = WallpaperManager.HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    try {
      final bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
      print(result);
    } catch (e) {
      print('Failed to set wallpaper: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set wallpaper: $e'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red[600],
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() {});
  }

  Future<void> setWallpaperLock() async {
    String url = widget.imgUrl;
    int location = WallpaperManager.LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    try {
      final bool result = await WallpaperManager.setWallpaperFromFile(
          file.path, location);
      print(result);
    } catch (e){
      print('Failed to set wallpaper: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set wallpaper: $e'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red[600],
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() {});
  }

  Future<void> setWallpaperBoth() async {
    String url = widget.imgUrl;
    int location = WallpaperManager.BOTH_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    try {
      final bool result = await WallpaperManager.setWallpaperFromFile(
          file.path, location);
      print(result);
    } catch(e){
      print('Failed to set wallpaper: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set wallpaper: $e'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red[600],
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() {});
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
                            boundaryMargin: const EdgeInsets.all(20),
                            minScale: 0.1,
                            maxScale: 4.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.imgUrl,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ),
                            ),
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
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 48, // Increase font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4), // Add spacing
                                    Text(
                                      _currentDay,
                                      style: const TextStyle(
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
                                  return SimpleDialog(
                                    title: const Text('Choose an option'),
                                    children: <Widget>[
                                      SimpleDialogOption(
                                        child: const Text('Set as Home Screen'),
                                        onPressed: () async {
                                          // Handle the "Set as Home Screen" option.
                                          await setWallpaperHome();
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: const Text('Set as Lock screen'),
                                        onPressed: () {
                                          // Handle the "Set as Lock screen" option.
                                          setWallpaperLock();
                                        },
                                      ),
                                      SimpleDialogOption(
                                        child: const Text('Set both'),
                                        onPressed: () {
                                          // Handle the "Set both" option.
                                          setWallpaperBoth();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              //setWallpaper();
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: mounted ? _toggleLike : null,
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
