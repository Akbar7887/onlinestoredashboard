class ProductImage {
  int? id;
  String? imagepath;
  bool? mainimg;

  ProductImage({
      this.id, 
      this.imagepath, 
      this.mainimg,});

  ProductImage.fromJson(dynamic json) {
    id = json['id'];
    imagepath = json['imagepath'];
    mainimg = json['mainimg'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['imagepath'] = imagepath;
    map['mainimg'] = mainimg;
    return map;
  }

}