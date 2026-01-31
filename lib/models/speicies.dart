class Spieces {
  Spieces({
    required this.id,
    required this.name,
    required this.category,
    this.categoryId,
    required this.ImgLink,
    required this.price,
    required this.spiceCost,
    required this.isFavourites,
    required this.isControll,
    required this.favBtn,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String category;
  late final int? categoryId;
  late final String ImgLink;
  late final int price;
  late final double spiceCost;
  late final bool isFavourites;
  late final bool isControll;
  late final String favBtn;
  late final String createdAt;
  late final String updatedAt;

  Spieces.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    categoryId = json['categoryId'] != null ? json['categoryId'] : null;
    ImgLink = json['ImgLink'];
    price = json['price'];
    spiceCost = json['spice_cost'];
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
    if (categoryId != null) {
      _data['categoryId'] = categoryId;
    }
    _data['ImgLink'] = ImgLink;
    _data['price'] = price;
    _data['spice_cost'] = spiceCost;
    _data['isFavourites'] = isFavourites;
    _data['isControll'] = isControll;
    _data['favBtn'] = favBtn;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
