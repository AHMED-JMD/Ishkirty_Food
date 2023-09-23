class Spiecies {
  Spiecies({
    required this.name,
    required this.type,
    required this.price,
    required this.imageLink,
  });

  late final String name;
  late final String type;
  late final String price;
  late final String imageLink;

  Spiecies.fromJson(Map<String, dynamic> json){
    name = json['name'];
    type = json['type'];
    price = json['price'];
    imageLink = json['image_link'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['type'] = type;
    _data['price'] = price;
    _data['image_link'] = imageLink;
    return _data;
  }
}
//get data mock from database
List<Spiecies> juices = [
  Spiecies(name: "برتقال", type: "juice", price: "500", imageLink: "juice.jpg"),
  Spiecies(name: "ليمون", type: "juice", price: "300", imageLink: "juice.jpg"),
  Spiecies(name: "منجا", type: "juice", price: "800", imageLink: "juice.jpg"),
  Spiecies(name: "مشكل", type: "juice", price: "1000", imageLink: "juice.jpg"),
];
//get data mock from database
List<Spiecies> traditional = [
  Spiecies(name: "طعمية", type: "traditional", price: "300", imageLink: "traditional.jpg"),
  Spiecies(name: "بيض", type: "traditional", price: "400", imageLink: "traditional.jpg"),
  Spiecies(name: "شبس", type: "traditional", price: "400", imageLink: "traditional.jpg"),
];
//get data mock from database
List<Spiecies> meat = [
  Spiecies(name: "شاورما", type: "meat", price: "300", imageLink: "meat.png"),
  Spiecies(name: "بيرقر", type: "meat", price: "400", imageLink: "meat.png"),
  Spiecies(name: "اقاشي", type: "meat", price: "400", imageLink: "meat.png"),
  Spiecies(name: "شيش طاووق", type: "meat", price: "400", imageLink: "meat.png"),
];
//get data mock from database
List<Spiecies> buftake = [
  Spiecies(name: "بفتيك", type: "buftake", price: "300", imageLink: "sandwich.jpg"),
  Spiecies(name: "كريسبي", type: "buftake", price: "400", imageLink: "sandwich.jpg"),
  Spiecies(name: "زنجر", type: "buftake", price: "400", imageLink: "sandwich.jpg"),
];
