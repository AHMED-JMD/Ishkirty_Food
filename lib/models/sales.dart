class Sales {
  Sales({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.BillId,
    this.SpieceId,
  });
  late final int id;
  late final String name;
  late final int price;
  late final int quantity;
  late final int amount;
  late final String createdAt;
  late final String updatedAt;
  late final int BillId;
  late final Null SpieceId;

  Sales.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    BillId = json['BillId'];
    SpieceId = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['quantity'] = quantity;
    _data['amount'] = amount;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['BillId'] = BillId;
    _data['SpieceId'] = SpieceId;
    return _data;
  }
}