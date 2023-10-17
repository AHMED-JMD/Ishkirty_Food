import 'package:ashkerty_food/models/sales.dart';

class Bill{

  Bill({
    required this.BillNumber,
    required this.BillDate,
    required this.BillTotal,
    required this.PaymentMethod,
    required this.SalesList,
});
late final int BillNumber;
late final String BillDate;
late final int BillTotal;
late final String PaymentMethod;
late final List<Sales> SalesList;

  Bill.fromJson(Map<String, dynamic> json){
    BillNumber=json['billnumber'];
    BillDate=json['billdate'];
    BillTotal=json['billtotal'];
    PaymentMethod=json['paymentmethod'];
    SalesList=json['saleslist'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['billnumber'] = BillNumber;
    data['billdate'] = BillDate;
    data['billtotal'] = BillTotal;
    data['paymentmethod'] = PaymentMethod;
    data['saleslist'] = SalesList;
    return data;
  }

List<Bill> Bills=[
    Bill(BillNumber:1,BillDate:'17/10/2023',BillTotal: 8200,PaymentMethod: 'BANKAK',SalesList: sales2),
    Bill(BillNumber:2,BillDate: '17/10/203', BillTotal: 17700, PaymentMethod: 'CASH', SalesList: sales),
];




}