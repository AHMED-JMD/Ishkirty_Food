class Cart {
  late String spices;
  late int counter;
  late String category;
  late List<String> addons;
  late int unit_price;
  late num total_price;

  Cart(
      {required this.spices,
      required this.counter,
      required this.category,
      required this.addons,
      required this.unit_price,
      required this.total_price});

  Cart.fromJson(Map<String, dynamic> json) {
    spices = json['spices'];
    counter = json['counter'];
    category = json['category'];
    addons = json['addons'];
    unit_price = json['unit_price'];
    total_price = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['spices'] = spices;
    _data['counter'] = counter;
    _data['category'] = category;
    _data['addons'] = addons;
    _data['unit_price'] = unit_price;
    _data['total_price'] = total_price;

    return _data;
  }
}
