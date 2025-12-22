class Spieces {
  Spieces({
    required this.id,
    required this.name,
    required this.category,
    required this.ImgLink,
    required this.price,
    required this.isFavourites,
    required this.isControll,
    required this.favBtn,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String category;
  late final String ImgLink;
  late final int price;
  late final bool isFavourites;
  late final bool isControll;
  late final String favBtn;
  late final String createdAt;
  late final String updatedAt;

  Spieces.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    category = json['category'];
    ImgLink = json['ImgLink'];
    price = json['price'];
    isFavourites = json['isFavourites'];
    isControll = json['isControll'];
    favBtn = json['favBtn'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['category'] = category;
    _data['ImgLink'] = ImgLink;
    _data['price'] = price;
    _data['isFavourites'] = isFavourites;
    _data['isControll'] = isControll;
    _data['favBtn'] = favBtn;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}