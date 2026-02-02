class Discharge {
  final String id;
  final String name;
  final double price;
  final DateTime date;
  final bool isMonthly;
  final String paymentMethod;
  final String admin;

  Discharge(
      {required this.id,
      required this.name,
      required this.price,
      required this.date,
      required this.isMonthly,
      required this.paymentMethod,
      required this.admin});

  factory Discharge.fromJson(Map<String, dynamic> json) {
    return Discharge(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (double.tryParse(json['price']?.toString() ?? '') ?? 0.0),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      isMonthly: (json['isMonthly'] is bool)
          ? json['isMonthly']
          : (json['isMonthly']?.toString() == '1' ||
              json['isMonthly']?.toString().toLowerCase() == 'true'),
      paymentMethod: json['payment_method'] ?? '',
      admin: json['admin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': price,
      'date': date.toIso8601String(),
      'isMonthly': isMonthly,
      'payment_method': paymentMethod,
      'admin': admin,
    };
  }
}
