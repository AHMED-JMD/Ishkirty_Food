class EmpTransaction {
  EmpTransaction({
    required this.id,
    required this.empId,
    required this.type,
    required this.amount,
    required this.date,
  });

  final int id;
  final int empId;
  final String type;
  final double amount;
  final DateTime date;

  factory EmpTransaction.fromJson(Map<String, dynamic> json) {
    return EmpTransaction(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      type: json['type'] ?? '',
      amount: json['amount'] is num
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount'].toString()) ?? 0.0,
      date: DateTime.parse(json['date'].toString()),
      empId: json['EmployeeId'] is int
          ? json['EmployeeId']
          : int.parse(json['EmployeeId'].toString()),
    );
  }
}
