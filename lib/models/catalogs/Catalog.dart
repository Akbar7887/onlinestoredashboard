import 'Product.dart';

class Catalog {
  int? id;
  String? catalogname;
  String? imagepath;
  String? active;
  List<Catalog>? catalogs;
  Catalog? parent;

  Catalog(
      {this.id,
      this.catalogname,
      this.imagepath,
      this.catalogs,
      this.parent});

  Catalog.fromJson(dynamic json) {
    id = json['id'];
    catalogname = json['catalogname'];
    imagepath = json['imagepath'];
    if (json['catalogs'] != null) {
      catalogs = [];
      json['catalogs'].forEach((v) {
        catalogs!.add(Catalog.fromJson(v));
      });
    }
    if(json['parent'] != null){
      parent = catalogs!.firstWhere((element) => element.parent == json['parent']);
    }

  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['catalogname'] = catalogname;
    map['imagepath'] = imagepath;
    if (catalogs != null) {
      map['catalogs'] = catalogs!.map((v) => v.toJson()).toList();
    }
    if (this.parent != null) {
      map['parent'] = this.parent!.toJson();
    }
    return map;
  }
}
