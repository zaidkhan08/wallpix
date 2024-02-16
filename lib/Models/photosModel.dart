class PhotosModel{
  String imgSrc;
  //String photographer;

  PhotosModel({
    required this.imgSrc,
    //required this.photographer
  });

  static PhotosModel fromAPI2App(Map<String, dynamic> photoMap){
    return PhotosModel(
        imgSrc: (photoMap["urls"])["regular"],
        //photographer: photoMap["photographer"]
    );
  }

}