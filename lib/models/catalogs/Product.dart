import 'dart:collection';

import 'package:onlinestoredashboard/models/catalogs/ProductImage.dart';

import 'Catalog.dart';
import 'Characteristic.dart';

class Product {
  int? id;
  String? name;
  String? description;
  dynamic? imagepath;
  String? active;
  List<ProductImage>? productImages;
  int? catalogId;
  List<Characteristic>? characteristics;
  Catalog? catalog;

  Product(
      {this.id,
      this.name,
      this.description,
      this.imagepath,
      this.active,
      this.productImages,
      this.catalogId,
      this.characteristics,
      this.catalog});

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
    catalogId = json['catalogId'];
    if(json['characteristics'] != null){
      characteristics = [];
      json['characteristics'].forEach((c){
        characteristics!.add(Characteristic.fromJson(c));
      });
    }
    catalog = json["catalog"];
  }

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
    if (characteristics != null) {
      map['characteristics'] = characteristics!.map((v) => v.toJson()).toList();
    }
    map['catalog'] = catalog;
    return map;
  }
}
