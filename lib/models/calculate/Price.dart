import 'Product.dart';

class Price {

  int? id;
  String? date;
  String? rates;
  double? price;
  Product? product;


  Price({
      this.id, 
      this.date, 
      this.rates, 
      this.price, 
      this.product,});

  Price.fromJson(dynamic json) {
    id = json['id'];
    date = json['date'];
    rates = json['rates'];
    price = json['price'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date;
    map['rates'] = rates;
    map['price'] = price;
    if (product != null) {
      map['product'] = product!.toJson();
    }
    return map;
  }

}