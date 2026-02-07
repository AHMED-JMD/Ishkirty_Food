class SpiecesTableModel {
  SpiecesTableModel({
    required this.id,
    required this.name,
    required this.category,
    required this.saleSum,
    required this.spiceCost,
    required this.price,
    required this.totSales,
    required this.totCosts,
  });

  late final String id;
  late final String name;
  late final String category;
  late final double saleSum;
  late final double spiceCost;
  late final double price;
  late final double totSales;
  late final double totCosts;

  SpiecesTableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'] ?? '';
    category = json['category'] ?? '';
    saleSum = (json['sum_quantity'] is int)
        ? (json['sum_quantity'] as int).toDouble()
        : (json['sum_quantity'] ?? 0.0);
    spiceCost = (json['spice_cost'] is int)
        ? (json['spice_cost'] as int).toDouble()
        : (json['spice_cost'] ?? 0.0);
    price = (json['price'] is int)
        ? (json['price'] as int).toDouble()
        : (json['price'] ?? 0.0);
    totSales = (json['tot_sales'] is int)
        ? (json['tot_sales'] as int).toDouble()
        : (json['tot_sales'] ?? 0.0);
    totCosts = (json['tot_costs'] is int)
        ? (json['tot_costs'] as int).toDouble()
        : (json['tot_costs'] ?? 0.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tot_sales': totSales,
      'tot_costs': totCosts,
    };
  }
}
