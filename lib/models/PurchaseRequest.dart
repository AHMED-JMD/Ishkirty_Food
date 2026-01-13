class PurchaseRequest {
  final String? id;
  final String vendor;
  final double quantity;
  final int buyPrice;
  final DateTime date;

  PurchaseRequest({
    this.id,
    required this.vendor,
    required this.quantity,
    required this.buyPrice,
    required this.date,
  });

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) {
    return PurchaseRequest(
      id: json['id']?.toString(),
      vendor: json['vendor']?.toString() ?? '',
      quantity: (json['quantity'] is int)
          ? (json['quantity'] as int).toDouble()
          : (double.tryParse(json['quantity']?.toString() ?? '') ?? 0.0),
      buyPrice: (json['buy_price'] is int)
          ? json['buy_price'] as int
          : (int.tryParse(json['buy_price']?.toString() ?? '') ?? 0),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'vendor': vendor,
      'quantity': quantity,
      'buy_price': buyPrice,
      'date': date.toIso8601String(),
    };
  }
}
