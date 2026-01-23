class Daily {
  final String id;
  final DateTime date;
  final double cashSales;
  final double bankSales;
  final double accountSales;
  final double totalCosts;
  final String businessLocation;

  Daily({
    required this.id,
    required this.date,
    required this.cashSales,
    required this.bankSales,
    required this.accountSales,
    required this.totalCosts,
    required this.businessLocation,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      id: json['id'].toString(),
      cashSales: (json['cash_sales'] ?? 0).toDouble(),
      bankSales: (json['bank_sales'] ?? 0).toDouble(),
      accountSales: (json['account_sales'] ?? 0).toDouble(),
      totalCosts: (json['total_costs'] ?? 0).toDouble(),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      businessLocation: json['business_location']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cash_sales': cashSales,
      'bank_sales': bankSales,
      'account_sales': accountSales,
      'total_costs': totalCosts,
      'date': date.toIso8601String(),
      'business_location': businessLocation,
    };
  }
}
