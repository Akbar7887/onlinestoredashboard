class Characteristic {

  int? id;
  String? name;
  String? valuename;
  int? productId;
  bool editable = false;

  Characteristic({
      this.id, 
      this.name, 
      this.valuename, 
      this.productId,});

  Characteristic.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    valuename = json['valuename'];
    productId = json['productId'];
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['valuename'] = valuename;
    map['productId'] = productId;
    return map;
  }

}