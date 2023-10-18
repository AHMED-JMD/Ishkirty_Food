import 'package:ashkerty_food/models/sales.dart';
class bill{
  bill({
    required this.BillNumber,
    required this.BillDate,
    required this.PaymentMethod,
    required this.TheSales,
});
late final int BillNumber;
late final String BillDate;
late final List<Sales> TheSales;
late  int  BillTotal = billTotall(TheSales) ;
late final String PaymentMethod;
  bill.fromJson(Map<String, dynamic> json){
    BillNumber=json['billnumber'];
    BillDate=json['billdate'];
    PaymentMethod=json['paymentmethod'];
    TheSales=json['TheSales'];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['billnumber'] = BillNumber;
    _data['billdate'] = BillDate;
    _data['paymentmethod'] = PaymentMethod;
    _data['TheSales']=TheSales;
    return _data;
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
  bill(BillNumber:1,BillDate:'17/10/2023',PaymentMethod: 'BANKAK',TheSales:sales2),
  bill(BillNumber:2,BillDate: '17/10/2023', PaymentMethod: 'CASH',TheSales:sales ),
];
