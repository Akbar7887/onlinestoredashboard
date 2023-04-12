import 'dart:collection';

import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';

import 'Catalog.dart';
import 'Characteristic.dart';

class Product {
  int? id;
  String? name;
  String? description;
  dynamic? imagepath;
  // String? active;
  List<ProductImage>? productImages;
  List<Characteristic>? characteristics;
  Catalog? catalog;
  String? codeproduct;

  Product(
      {this.id,
      this.name,
      this.description,
      this.imagepath,
      // this.active,
      this.productImages,
      this.characteristics,
      this.codeproduct});

  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imagepath = json['imagepath'];
    // active = json['active'];
    if (json['productImages'] != null) {
      productImages = [];
      json['productImages'].forEach((v) {
        productImages!.add(ProductImage.fromJson(v));
      });
    }
    catalog =
        json['catalog'] != null ? Catalog.fromJson(json['catalog']) : null;
    codeproduct = json['codeproduct'];

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['imagepath'] = imagepath;
    // map['active'] = active;
    if (productImages != null) {
      map['productImages'] = productImages!.map((v) => v.toJson()).toList();
    }
    if (this.catalog != null) {
      map['catalog'] = this.catalog!.toJson();
    }
    map['codeproduct'] = this.codeproduct;

    return map;
  }
}
