//speices class for storing the data coming from the database



class Spiecies {

  Spiecies({
    required this.name,
    required this.type,
    required this.price,
    required this.imageLink,
  });

  late final String name;
  late final String type;
  late final int price;
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
  Spiecies(name: "مشكل", type: "juice", price: 1300, imageLink: "juice.jpg"),
  Spiecies(name: "فراولة بالحليب", type: "juice", price: 1100, imageLink: "juice.jpg"),
  Spiecies(name: " اناناس بالحليب", type: "juice", price: 1000, imageLink: "juice.jpg"),
  Spiecies(name: "مانجا بالحليب", type: "juice", price: 1000, imageLink: "juice.jpg"),
  Spiecies(name: "برتقال 2*1", type: "juice", price: 800, imageLink: "juice.jpg"),
  Spiecies(name: "برتقال 1*1", type: "juice", price: 600, imageLink: "juice.jpg"),
  Spiecies(name: "موز باللبن", type: "juice", price: 800, imageLink: "juice.jpg"),
  Spiecies(name: "ليمون", type: "juice", price: 500, imageLink: "juice.jpg"),
];
//get data mock from database
List<Spiecies> traditional = [
  Spiecies(name: "طعمية", type: "traditional", price: 500, imageLink: "traditional.jpg"),
  Spiecies(name: "بيض", type: "traditional", price: 500, imageLink: "traditional.jpg"),
  Spiecies(name: "شبس", type: "traditional", price: 600, imageLink: "traditional.jpg"),
  Spiecies(name: "ميكس اشكرتي", type: "traditional", price: 1200, imageLink: "traditional.jpg"),
];
//get data mock from database
List<Spiecies> meat = [
  Spiecies(name: "شاورما", type: "meat", price: 2000, imageLink: "meat.png"),
  Spiecies(name: "بيرقر", type: "meat", price: 1400, imageLink: "meat.png"),
  Spiecies(name: "اقاشي", type: "meat", price: 1500, imageLink: "meat.png"),
  Spiecies(name: "شيش طاووق", type: "meat", price: 2000, imageLink: "meat.png"),
  Spiecies(name: "بيرقر جامبو", type: "meat", price: 2000, imageLink: "meat.png"),
  Spiecies(name: "بوفتيك", type: "meat", price: 1000, imageLink: "meat.png"),
  Spiecies(name: "كرسبي", type: "meat", price: 2500, imageLink: "sandwich.jpg"),
  Spiecies(name: "زنجر", type: "meat", price: 2500, imageLink: "sandwich.jpg"),
];
//get data mock from database

final int number_of_spiecies=  meat.length + traditional.length + juices.length;
List<Spiecies> All =   meat + traditional + juices ;