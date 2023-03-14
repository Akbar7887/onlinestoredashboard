import 'Product.dart';

class ProductImage {
  int? id;
  String? imagepath;
  bool? mainimg;
  Product? product;

  ProductImage({
      this.id, 
      this.imagepath, 
      this.mainimg,
  this.product});

  ProductImage.fromJson(dynamic json) {
    id = json['id'];
    imagepath = json['imagepath'];
    mainimg = json['mainimg'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['imagepath'] = imagepath;
    map['mainimg'] = mainimg;
    if (this.product != null) {
      map['product'] = this.product!.toJson();
    }
    return map;
  }

}