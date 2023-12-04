import 'package:ashkerty_food/models/sales.dart';

class bill{
  bill({
    required this.BillNumber,
    required this.BillDate,
    required this.PaymentMethod,
    required this.TheSales,
    required this.shift,
});
late final int BillNumber;
late final String BillDate;
late final List<Sales> TheSales;
late  int  BillTotal = billTotall(TheSales) ;
late final String PaymentMethod;
late final String shift;
  bill.fromJson(Map<String, dynamic> json){
    BillNumber=json['billnumber'];
    BillDate=json['billdate'];
    PaymentMethod=json['paymentmethod'];
    TheSales=json['TheSales'];
    shift=json['shift'];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['billnumber'] = BillNumber;
    data['billdate'] = BillDate;
    data['paymentmethod'] = PaymentMethod;
    data['TheSales']=TheSales;
    data['shift']=shift;
    return data;
  }

  int billTotall(List<Sales> theSales) {
    int BillTotal=0;
    for (int i = 0; i < TheSales.length; i++) {
      BillTotal += TheSales[i].totall;

    }
    return BillTotal;
  }


}
List<bill> bill1 =[
  bill(BillNumber:1,BillDate:'17/10/2023',PaymentMethod: 'BANKAK',TheSales:sales2,shift: 'صباحية'),
  bill(BillNumber:2,BillDate: '17/10/2023', PaymentMethod: 'CASH',TheSales:sales,shift: 'صباحية' ),
  bill(BillNumber:3, BillDate: '17/10/2023', PaymentMethod: 'ACCOUNT', TheSales: sales3,shift:'مسائية'),
];
