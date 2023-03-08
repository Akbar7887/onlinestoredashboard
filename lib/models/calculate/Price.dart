import 'package:onlinestoredashboard/models/catalogs/Product.dart';

class Price {
  int? id;
  String? date;
  String? rates;
  double? price;
  Product? product;
  double? pricesum;

  Price({
    this.id,
    this.date,
    this.rates,
    this.price,
    this.pricesum,
    this.product,
  });

  Price.fromJson(dynamic json) {
    id = json['id'];
    date = json['date'];
    rates = json['rates'];
    price = json['price'];
    pricesum = json['pricesum'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date;
    map['rates'] = rates;
    map['price'] = price;
    map['pricesum'] = pricesum;
    if (product != null) {
      map['product'] = product!.toJson();
    }
    return map;
  }
}
