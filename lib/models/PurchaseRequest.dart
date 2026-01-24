import 'package:ashkerty_food/models/StockItem.dart';

class PurchaseRequest {
  final String id;
  final String vendor;
  final double quantity;
  final double netQuantity;

  final int buyPrice;
  final DateTime date;
  final String paymentMethod;
  final StockItem store;

  PurchaseRequest({
    required this.id,
    required this.vendor,
    required this.quantity,
    required this.netQuantity,
    required this.buyPrice,
    required this.date,
    required this.paymentMethod,
    required this.store,
  });

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) {
    return PurchaseRequest(
      id: json['id'].toString(),
      vendor: json['vendor'],
      quantity: json['quantity'],
      netQuantity: json['net_quantity'],
      buyPrice: (json['buy_price'] is int)
          ? json['buy_price'] as int
          : (int.tryParse(json['buy_price']?.toString() ?? '') ?? 0),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      paymentMethod: json['payment_method'] ?? '',
      store: StockItem.fromJson(json['Store']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendor': vendor,
      'quantity': quantity,
      'net_quantity': netQuantity,
      'buy_price': buyPrice,
      'date': date.toIso8601String(),
      'payment_method': paymentMethod,
      'Store': store.toJson(),
    };
  }
}
