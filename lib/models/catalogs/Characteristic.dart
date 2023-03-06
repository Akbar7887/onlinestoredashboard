import 'package:onlinestoredashboard/models/catalogs/Product.dart';

class Characteristic {

  int? id;
  String? name;
  String? valuename;
  int? productId;
  Product? product;

  Characteristic({
      this.id, 
      this.name, 
      this.valuename, 
      this.productId,
  this.product});

  Characteristic.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    valuename = json['valuename'];
    productId = json['productId'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['valuename'] = valuename;
    map['productId'] = productId;
    if (this.product != null) {
      map['product'] = this.product!.toJson();
    }
    return map;
  }

}