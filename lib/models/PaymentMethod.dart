//method amount and accountId data class
class PaymentMethod {
  PaymentMethod({
    required this.method,
    required this.amount,
    required this.accountId,
  });
  late final String method;
  late final int amount;
  late final int? accountId;

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    amount = json['amount'];
    accountId = json['accountId'] == null ? null : json['accountId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['method'] = method;
    _data['amount'] = amount;
    _data['accountId'] = accountId;
    return _data;
  }
}
