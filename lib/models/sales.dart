//speices class for storing the data coming from the database
class Sales {
  Sales({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.date,
  });

  late final String id;
  late final String name;
  late final String type;
  late final int price;
  late final String date;

  Sales.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    price = json['price'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['price'] = price;
    _data['date'] = date;
    return _data;
  }
}
//get data mock from database
List<Sales> sales = [
  Sales(id : '1', name: "برتقال", type: "juice", price: 500, date: "02-10-2023"),
  Sales(id : '2', name: "بيرقر", type: "meat", price: 300, date: "02-10-2023"),
  Sales(id : '3', name: "طعمية", type: "traditional", price: 800, date: "02-10-2023"),
  Sales(id : '4', name: "كريسبي", type: "bufteak", price: 1000, date: "02-10-2023"),
  Sales(id : '5', name: "اناناس", type: "juice", price: 1100, date: "02-10-2023"),
];
