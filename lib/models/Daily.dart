class Daily {
  final String id;
  final DateTime date;
  final double cashSales;
  final double bankSales;
  final double accountSales;
  final double spiceCosts;
  final double cashCosts;
  final double bankCosts;
  final double accountCosts;
  final String businessLocation;
  final bool isCreated;
  final bool isAddedtoSafe;

  Daily({
    required this.id,
    required this.date,
    required this.cashSales,
    required this.bankSales,
    required this.accountSales,
    required this.spiceCosts,
    required this.cashCosts,
    required this.bankCosts,
    required this.accountCosts,
    required this.businessLocation,
    required this.isCreated,
    required this.isAddedtoSafe,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      id: json['id'].toString(),
      cashSales: (json['cash_sales'] ?? 0).toDouble(),
      bankSales: (json['bank_sales'] ?? 0).toDouble(),
      accountSales: (json['account_sales'] ?? 0).toDouble(),
      spiceCosts: (json['spices_costs'] ?? 0).toDouble(),
      cashCosts: (json['cash_costs'] ?? 0).toDouble(),
      bankCosts: (json['bank_costs'] ?? 0).toDouble(),
      accountCosts: (json['account_costs'] ?? 0).toDouble(),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      businessLocation: json['business_location']?.toString() ?? '',
      isCreated: json['isCreated'] ?? false,
      isAddedtoSafe: json['isAddedtoSafe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cash_sales': cashSales,
      'bank_sales': bankSales,
      'account_sales': accountSales,
      'spices_costs': spiceCosts,
      'cash_costs': cashCosts,
      'bank_costs': bankCosts,
      'account_costs': accountCosts,
      'date': date.toIso8601String(),
      'business_location': businessLocation,
      'isCreated': isCreated,
      'isAddedtoSafe': isAddedtoSafe,
    };
  }
}
