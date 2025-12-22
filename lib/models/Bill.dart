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
    this.AdminAdminId,
    required this.comment,
    this.admin,
  });
  late final int id;
  late final int amount;
  late final Null isDeleted;
  late final String paymentMethod;
  late final String date;
  late final String shiftTime;
  late final createdAt;
  late final String updatedAt;
  late final Null ClientId;
  late final AdminAdminId;
  late final String comment;
  late final admin;

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
    AdminAdminId = json['AdminAdminId'];
    comment = json['comment'];
    admin = json['admin'];
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
    _data['AdminAdminId'] = AdminAdminId;
    _data['comment'] = comment;
    _data['admin'] = admin;
    return _data;
  }
}