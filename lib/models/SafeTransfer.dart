class SafeTransfer {
  final String? id;
  final DateTime date;
  final String from;
  final String to;
  final double amount;
  final String? clientId;
  final String? safeId;

  SafeTransfer({
    this.id,
    required this.date,
    required this.from,
    required this.to,
    required this.amount,
    this.clientId,
    this.safeId,
  });

  factory SafeTransfer.fromJson(Map<String, dynamic> json) {
    return SafeTransfer(
      id: json['id']?.toString(),
      date: DateTime.parse(json['date']),
      from: json['from'],
      to: json['to'],
      amount: (json['amount'] as num).toDouble(),
      clientId: json['clientId']?.toString(),
      safeId: json['safeId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'from': from,
      'to': to,
      'amount': amount,
      'clientId': clientId,
      'safeId': safeId,
    };
  }
}
