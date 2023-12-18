import 'package:ashkerty_food/models/sales.dart';

class bill{
  bill({
    required this.bill_id,
    required this.amount,
    required this.isDeleted,
    required this.paymentMethod,
    required this.date,
    required this.shiftTime,
    required this.createdAt,
    required this.updatedAt,
    required this.ClientId,
});
  late final String bill_id;
  late final String date;
  late final int amount;
  late final Null isDeleted;
  late final String paymentMethod;
  late final String shiftTime;
  late final String createdAt;
  late final String updatedAt;
  late final Null ClientId;

  bill.fromJson(Map<String, dynamic> json){
    bill_id=json['bill_id'];
    amount=json['amount'];
    isDeleted=json['isDeleted'];
    paymentMethod=json['paymentMethod'];
    date=json['date'];
    shiftTime=json['shiftTime'];
    createdAt=json['createdAt'];
    updatedAt=json['updatedAt'];
    ClientId=json['ClientId'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bill_id'] = bill_id;
    data['amount'] = amount;
    data['isDeleted'] = isDeleted;
    data['paymentMethod']= paymentMethod;
    data['date']= date;
    data['shiftTime'] = shiftTime;
    data['createdAt'] = createdAt;
    data['updatedAt']= updatedAt;
    data['ClientId']= ClientId;

    return data;
  }
}
