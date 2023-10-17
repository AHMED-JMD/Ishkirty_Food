//speices class for storing the data coming from the database
class Sales {
  Sales({
    required this.Bill_Number,
    required this.Payment_Method,
    required this.name,
    required this.type,
    required this.price,
    required this.date,
    required this.quantity,
  });
  late final String Payment_Method;
  late final String Bill_Number;
  late final String name;
  late final String type;
  late final int quantity;
  late final int price;
  late final String date;

  Sales.fromJson(Map<String, dynamic> json){
    Bill_Number = json['id'];
    name = json['name'];
    type = json['type'];
    price = json['price'];
    date = json['date'];
    quantity=json['quantity'];
    Payment_Method=json['Payment_Method'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = Bill_Number;
    data['name'] = name;
    data['type'] = type;
    data['quantity'] = quantity;
    data['price'] = price;
    data['date'] = date;
    data['Payment_Method']=Payment_Method;

    return data;
  }
}
//get data mock from database
List<Sales> sales = [
  Sales(Bill_Number : '1', name: "برتقال", type: "juice", price: 600, date: "16-10-2023",quantity:2,Payment_Method:'bankak'),
  Sales(Bill_Number : '2', name: "بيرقر", type: "meat", price: 2000, date: "16-10-2023",quantity:2,Payment_Method:'bankak'),
  Sales(Bill_Number : '4', name: "كريسبي", type: "bufteak", price: 2500, date: "16-10-2023",quantity:3,Payment_Method:'bankak'),
  Sales(Bill_Number : '5', name: "اناناس", type: "juice", price: 1000, date: "16-10-2023",quantity:3,Payment_Method:'bankak'),
];
List<Sales> sales2 = [
  Sales(Bill_Number : '1', name: "برتقال", type: "juice", price: 600, date: "16-10-2023",quantity:2,Payment_Method:'bankak'),
  Sales(Bill_Number : '2', name: "بيرقر", type: "meat", price: 2000, date: "16-10-2023",quantity:1,Payment_Method:'bankak'),
  Sales(Bill_Number : '4', name: "كريسبي", type: "bufteak", price: 2500, date: "16-10-2023",quantity:2,Payment_Method:'bankak'),

];
