import 'Catalog.dart';

class Product {
  int? id;
  String? name;
  String? description;
  String? imagepath;
  String? active;
  Catalog? catalog;
  int? catalogId;

  Product({
      this.id, 
      this.name, 
      this.description, 
      this.imagepath, 
      this.active, 
      this.catalog, 
      this.catalogId,});

  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imagepath = json['imagepath'];
    active = json['active'];
    catalog = json['catalog'] != null ? Catalog.fromJson(json['catalog']) : null;
    catalogId = json['catalogId'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['imagepath'] = imagepath;
    map['active'] = active;
    if (catalog != null) {
      map['catalog'] = catalog!.toJson();
    }
    map['catalogId'] = catalogId;
    return map;
  }

}