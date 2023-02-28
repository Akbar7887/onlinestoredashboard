class Characteristic {
    int? id;
    String? name;
    int? productId;
    String? valuename;

    Characteristic({this.id, this.name, this.productId, this.valuename});

    factory Characteristic.fromJson(Map<String, dynamic> json) {
        return Characteristic(
            id: json['id'], 
            name: json['name'], 
            productId: json['productId'], 
            valuename: json['valuename'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        data['productId'] = this.productId;
        data['valuename'] = this.valuename;
        return data;
    }
}