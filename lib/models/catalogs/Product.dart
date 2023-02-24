import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';

class Product {
  Product({
      this.id, 
      this.name, 
      this.description, 
      this.imagepath, 
      this.active, 
      this.productImages,});

  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imagepath = json['imagepath'];
    active = json['active'];
    if (json['productImages'] != null) {
      productImages = [];
      json['productImages'].forEach((v) {
        productImages!.add(ProductImage.fromJson(v));
      });
    }
  }
  int? id;
  String? name;
  String? description;
  dynamic? imagepath;
  String? active;
  List<ProductImage>? productImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['imagepath'] = imagepath;
    map['active'] = active;
    if (productImages != null) {
      map['productImages'] = productImages!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}