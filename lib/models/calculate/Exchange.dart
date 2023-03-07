class Exchange {

  int? id;
  String? date;
  String? rates;
  double? ratevalue;


  Exchange({
      this.id, 
      this.date, 
      this.rates, 
      this.ratevalue,});

  Exchange.fromJson(dynamic json) {
    id = json['id'];
    date = json['date'];
    rates = json['rates'];
    ratevalue = json['ratevalue'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date;
    map['rates'] = rates;
    map['ratevalue'] = ratevalue;
    return map;
  }

}