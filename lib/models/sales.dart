//speices class for storing the data coming from the database
class Sales {
  Sales({
    required this.name,
    required this.type,
    required this.price,
    required this.quantity,
  });

  late final String name;
  late final String type;
  late final int quantity;
  late final int price;

  Sales.fromJson(Map<String, dynamic> json){
    name = json['name'];
    type = json['type'];
    price = json['price'];
    quantity=json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}
//get data mock from database
List<Sales> sales = [
  Sales( name: "برتقال", type: "juice", price: 600,quantity:2,),
  Sales( name: "بيرقر", type: "meat", price: 2000, quantity:2,),
  Sales( name: "كريسبي", type: "bufteak", price: 2500, quantity:3,),
  Sales( name: "اناناس", type: "juice", price: 1000, quantity:3,),
];
List<Sales> sales2 = [
  Sales( name: "برتقال", type: "juice", price: 600,quantity:2,),
  Sales(  name: "بيرقر", type: "meat", price: 2000,quantity:1,),
  Sales( name: "كريسبي", type: "bufteak", price: 2500,quantity:2,),

];
