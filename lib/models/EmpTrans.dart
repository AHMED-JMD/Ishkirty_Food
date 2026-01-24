class EmpTransaction {
  EmpTransaction({
    required this.id,
    required this.empId,
    required this.type,
    required this.employeeName,
    required this.amount,
    required this.date,
    required this.paymentMethod,
  });

  final int id;
  final int empId;
  final String type;
  final String employeeName;
  final double amount;
  final DateTime date;
  final String paymentMethod;

  factory EmpTransaction.fromJson(Map<String, dynamic> json) {
    return EmpTransaction(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      type: json['type'] ?? '',
      employeeName: json['employee_name'] ?? '',
      amount: json['amount'] is num
          ? (json['amount'] as num).toDouble()
          : double.tryParse(json['amount'].toString()) ?? 0.0,
      date: DateTime.parse(json['date'].toString()),
      empId: json['EmployeeId'] is int
          ? json['EmployeeId']
          : int.parse(json['EmployeeId'].toString()),
      paymentMethod: json['payment_method'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'EmployeeId': empId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
    };
  }
}
