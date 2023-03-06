import 'Product.dart';

class Catalog {
  int? id;
  String? catalogname;
  String? imagepath;
  String? active;
  List<Catalog>? catalogs;
  // List<Product>? products;
  int? parentId;
  Catalog? parent;

  Catalog(
      {this.id,
      this.catalogname,
      this.imagepath,
      this.active,
      this.catalogs,
      // this.products,
      this.parentId,
      this.parent});

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
    // if (json['products'] != null) {
    //   products = [];
    //   json['products'].forEach((v) {
    //     products!.add(Product.fromJson(v));
    //   });
    // }
    parentId = json['parentId'];

    if(json['parentId'] != null){
      parent = catalogs!.firstWhere((element) => element.parent!.id == json['parentId']);
    }

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['catalogname'] = catalogname;
    map['imagepath'] = imagepath;
    map['active'] = active;
    if (catalogs != null) {
      map['catalogs'] = catalogs!.map((v) => v.toJson()).toList();
    }
    // if (products != null) {
    //   map['products'] = products!.map((v) => v.toJson()).toList();
    // }
    map["parentId"] = parentId;
    return map;
  }
}
