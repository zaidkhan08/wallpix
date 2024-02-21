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
      "Flowers",
      "Food"
    ];
    List categoryUrl = [
      "https://images.unsplash.com/photo-1532581140115-3e355d1ed1de?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1874&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1581262177000-8139a463e531?q=80&w=1915&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1508610048659-a06b669e3321?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "https://images.unsplash.com/photo-1484723091739-30a097e8f929?q=80&w=1547&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"

    ];
    categoryModelList.clear();
      for(int i = 0; i < categoryName.length; i++){
        categoryModelList.add(CategoryModel(catImgUrl: categoryUrl[i], catName: categoryName[i]));
      }
    return categoryModelList;
  }
}