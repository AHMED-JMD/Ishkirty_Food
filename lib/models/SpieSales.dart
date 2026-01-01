class SpiecesSales {
  late String name;
  late String category;
  late int totSales;

  SpiecesSales({
    required this.name,
    required this.category,
    required this.totSales,
  });

  SpiecesSales.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    category = json['category'];
    totSales = json['tot_sales'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['category'] = category;
    _data['tot_sales'] = totSales;

    return _data;
  }
}
