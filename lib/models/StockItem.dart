class StockItem {
  String id;
  String name;
  double quantity;
  double warnValue;
  double sellPrice;
  bool isKilo;
  DateTime? createdAt;
  DateTime? updatedAt;

  StockItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.warnValue,
    required this.sellPrice,
    required this.isKilo,
    this.createdAt,
    this.updatedAt,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      quantity: (json['quantity'] is num)
          ? (json['quantity'] as num).toDouble()
          : double.tryParse(json['quantity'].toString()) ?? 0.0,
      warnValue: (json['warn_value'] is num)
          ? (json['warn_value'] as num).toDouble()
          : double.tryParse(json['warn_value'].toString()) ?? 0.0,
      sellPrice: (json['price'] is num)
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,
      isKilo: json['isKilo'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sellPrice': sellPrice,
        'quantity': quantity,
        'isKilo': isKilo,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };
}
