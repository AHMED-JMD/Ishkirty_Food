class SafeDaily {
  final String? id;
  final DateTime date;
  final double totalCash;
  final double totalBank;
  final double totalDept;
  final String safeId;
  final String DailyId;

  SafeDaily({
    this.id,
    required this.date,
    required this.totalCash,
    required this.totalBank,
    required this.totalDept,
    required this.safeId,
    required this.DailyId,
  });

  factory SafeDaily.fromJson(Map<String, dynamic> json) {
    return SafeDaily(
      id: json['id']?.toString(),
      date: DateTime.parse(json['date']),
      totalCash: (json['total_cash'] as num).toDouble(),
      totalBank: (json['total_bank'] as num).toDouble(),
      totalDept: (json['total_dept'] as num).toDouble(),
      safeId: json['SafeId'].toString(),
      DailyId: json['DailyId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'total_cash': totalCash,
      'total_bank': totalBank,
      'total_dept': totalDept,
      'safeId': safeId,
    };
  }
}
