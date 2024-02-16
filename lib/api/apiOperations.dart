import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../Models/categoryModels.dart';
import '../Models/photosModel.dart';

class apiOperations{
  static List<PhotosModel> trendingWallpapers = [];
  static List<PhotosModel> searchWallpapersList = [];
  static List<CategoryModel> categoryModelList = [];

  static Future<List<PhotosModel>> getTrendingWallpapers() async{
    await http.get(
      Uri.parse('https://api.unsplash.com/photos/random?count=4'),
      headers: {'Authorization': 'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA'}
    ).then((value){
      Map<String , dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['urls'];
      photos.forEach((element) {
        trendingWallpapers.add(PhotosModel.fromAPI2App(element));
      });
    });
    return trendingWallpapers;
  }

  static Future<List<PhotosModel>> searchWallpapers(String query) async{
    await http.get(
        Uri.parse('https://api.unsplash.com/search/photos?query=$query&per_page=30&page=1'),
        headers: {'Authorization': 'Client-ID VkJ1pjeHCeggkyQ7sq7aSeB5vddGTEuWYB6jdrZdvYA'}
    ).then((value){

      Map<String , dynamic> jsonData = jsonDecode(value.body);
      List photos = jsonData['urls'];
      if (photos != null) {
        searchWallpapersList.clear();
        photos.forEach((element) {
          searchWallpapersList.add(PhotosModel.fromAPI2App(element));
        });
      }
    });
    return searchWallpapersList;
  }

  static List<CategoryModel> getCategoriesList() {
    List categoryName = [
      "Cars",
      "Games",
      "Code",
      "Nature",
      "Bikes",
      "Street",
      "City",
      "Flowers"
    ];
    categoryModelList.clear();
    categoryName.forEach((catName) async {
      final _random = new Random();

      PhotosModel photoModel =
      (await searchWallpapers(catName))[0 + _random.nextInt(11 - 0)];
      print("IMG SRC IS HERE");
      print(photoModel.imgSrc);
      categoryModelList.add(CategoryModel(catImgUrl: photoModel.imgSrc, catName: catName));
    });

    return categoryModelList;
  }
}