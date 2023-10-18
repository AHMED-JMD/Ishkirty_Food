//speices class for storing the data coming from the database


class Client {

  Client({
    required this.id,
    required this.name,
    required this.account,

  });

  late final String id;
  late final String name;
  late final int account;


  Client.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    account = json['account'];

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['account'] = account;

    return _data;
  }
}
//get data mock from database
List<Client> Clients = [
  Client(id : '1', name: "عدي عباس", account: 2000),
  Client(id : '2', name: "عبدالسلام عوض", account: 3000),
  Client(id : '3', name: "أحمدعبد الرحمن", account:4000 ),
  Client(id : '4', name: "محمد خير عبدالرحيم", account: 5000),
  Client(id : '5', name: "عدي عبدالمنعم", account: 6000),
];
