
import 'Product.dart';

class Catalog {
  Catalog({
      this.id, 
      this.catalogname, 
      this.imagepath, 
      this.active, 
      this.catalogs, 
      this.products,});

  Catalog.fromJson(dynamic json) {
    id = json['id'];
    catalogname = json['catalogname'];
    imagepath = json['imagepath'];
    active = json['active'];
    if (json['catalogs'] != null) {
      catalogs = [];
      json['catalogs'].forEach((v) {
        catalogs!.add(Catalog.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }
  int? id;
  String? catalogname;
  String? imagepath;
  String? active;
  List<Catalog>? catalogs;
  List<Product>? products;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['catalogname'] = catalogname;
    map['imagepath'] = imagepath;
    map['active'] = active;
    if (catalogs != null) {
      map['catalogs'] = catalogs!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      map['products'] = products!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}