class SpiecesTableModel {
  SpiecesTableModel({
    required this.id,
    required this.name,
    required this.category,
    required this.totSales,
    required this.totCosts,
  });

  late final String id;
  late final String name;
  late final String category;
  late final double totSales;
  late final double totCosts;

  SpiecesTableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'] ?? '';
    category = json['category'] ?? '';
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
