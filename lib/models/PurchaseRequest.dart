import 'package:ashkerty_food/models/StockItem.dart';

class PurchaseRequest {
  final String id;
  final String vendor;
  final double quantity;
  final int buyPrice;
  final DateTime date;
  final StockItem store;

  PurchaseRequest({
    required this.id,
    required this.vendor,
    required this.quantity,
    required this.buyPrice,
    required this.date,
    required this.store,
  });

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) {
    return PurchaseRequest(
      id: json['id'].toString(),
      vendor: json['vendor'],
      quantity: json['quantity'],
      buyPrice: (json['buy_price'] is int)
          ? json['buy_price'] as int
          : (int.tryParse(json['buy_price']?.toString() ?? '') ?? 0),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      store: StockItem.fromJson(json['Store']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor': vendor,
      'quantity': quantity,
      'buy_price': buyPrice,
      'date': date.toIso8601String(),
      'Store': store.toJson(),
    };
  }
}
