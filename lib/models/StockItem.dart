class StockItem {
  String? id;
  String name;
  double sellPrice;
  double buyPrice;
  int quantity;

  StockItem({
    this.id,
    required this.name,
    required this.sellPrice,
    required this.buyPrice,
    required this.quantity,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        id: json['_id']?.toString() ?? json['id']?.toString(),
        name: json['name'] ?? '',
        sellPrice: (json['sellPrice'] is num)
            ? (json['sellPrice'] as num).toDouble()
            : double.tryParse(json['sellPrice'].toString()) ?? 0.0,
        buyPrice: (json['buyPrice'] is num)
            ? (json['buyPrice'] as num).toDouble()
            : double.tryParse(json['buyPrice'].toString()) ?? 0.0,
        quantity: (json['quantity'] is num)
            ? (json['quantity'] as num).toInt()
            : int.tryParse(json['quantity'].toString()) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) '_id': id,
        'name': name,
        'sellPrice': sellPrice,
        'buyPrice': buyPrice,
        'quantity': quantity,
      };
}
