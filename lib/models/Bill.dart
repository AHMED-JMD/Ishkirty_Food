class bill {
  bill({
    required this.id,
    required this.amount,
    this.isDeleted,
    required this.paymentMethod,
    required this.date,
    required this.shiftTime,
    required this.createdAt,
    required this.updatedAt,
    this.ClientId,
    required this.comment,
  });
  late final int id;
  late final int amount;
  late final Null isDeleted;
  late final String paymentMethod;
  late final String date;
  late final String shiftTime;
  late final String createdAt;
  late final String updatedAt;
  late final Null ClientId;
  late final String comment;

  bill.fromJson(Map<String, dynamic> json){
    id = json['id'];
    amount = json['amount'];
    isDeleted = null;
    paymentMethod = json['paymentMethod'];
    date = json['date'];
    shiftTime = json['shiftTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ClientId = null;
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['amount'] = amount;
    _data['isDeleted'] = isDeleted;
    _data['paymentMethod'] = paymentMethod;
    _data['date'] = date;
    _data['shiftTime'] = shiftTime;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['ClientId'] = ClientId;
    _data['comment'] = comment;
    return _data;
  }
}