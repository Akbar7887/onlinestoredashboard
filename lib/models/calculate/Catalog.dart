class Catalog {
  int? id;
  String? catalogname;
  String? imagepath;
  String? active;
  List<dynamic>? catalogs;

  Catalog({
      this.id, 
      this.catalogname, 
      this.imagepath, 
      this.active, 
      this.catalogs,});

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
    return map;
  }

}