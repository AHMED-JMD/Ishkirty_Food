class Client {
  Client({
    required this.id,
    required this.name,
    required this.phoneNum,
    required this.account,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final int phoneNum;
  late final int account;
  late final String createdAt;
  late final String updatedAt;

  Client.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    phoneNum = json['phoneNum'];
    account = json['account'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phoneNum'] = phoneNum;
    _data['account'] = account;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}