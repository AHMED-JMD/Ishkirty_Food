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
  Spiecies(name: "مشكل", type: "juice", price: 1300, imageLink: "cocktail.jpg"),
  Spiecies(name: "فراولة بالحليب", type: "juice", price: 1100, imageLink: "smj.jpg"),
  Spiecies(name: " اناناس بالحليب", type: "juice", price: 1000, imageLink: "ananas-milk.jpg"),
  Spiecies(name: "مانجا بالحليب", type: "juice", price: 1000, imageLink: "mango-smoothie.jpg"),
  Spiecies(name: "برتقال 2*1", type: "juice", price: 800, imageLink: "orange.gif"),
  Spiecies(name: "مشروبات غازية", type: "juice", price: 700, imageLink: "kinza.jpg"),
  Spiecies(name: "برتقال 1*1", type: "juice", price: 600, imageLink: "orange1x1.jpg"),
  Spiecies(name: "موز باللبن", type: "juice", price: 600, imageLink: "banana-milk.jpg"),
  Spiecies(name: "ليمون", type: "juice", price: 500, imageLink: "lemon.jpg"),
  Spiecies(name: "مياه معدنية", type: "juice", price: 300, imageLink: "water.jpg"),

];
//get data mock from database
List<Spiecies> traditional = [
  Spiecies(name: "ميكس اشكرتي", type: "traditional", price: 1200, imageLink: "mix.jpg"),
  Spiecies(name: "شبس", type: "traditional", price: 600, imageLink: "fries.jpg"),
  Spiecies(name: " بيض باللحمة", type: "traditional", price: 600, imageLink: "egg-meat.jpg"),
  Spiecies(name: "طعمية", type: "traditional", price: 500, imageLink: "traditional.jpg"),
  Spiecies(name: "بيض", type: "traditional", price: 500, imageLink: "egg.jpg"),
  Spiecies(name: "فول ", type: "traditional", price: 400, imageLink: "fool.jpg"),


];
//get data mock from database
List<Spiecies> meat = [
  Spiecies(name: "كرسبي", type: "meat", price: 2500, imageLink: "krispy.jpg"),
  Spiecies(name: "زنجر", type: "meat", price: 2500, imageLink: "zinger.jpg"),
  Spiecies(name: "شاورما", type: "meat", price: 2500, imageLink: "shawirma.jpg"),
  Spiecies(name: "بيرقر جامبو", type: "meat", price: 2000, imageLink: "double-burger.jpg"),
  Spiecies(name: "شيش طاووق", type: "meat", price: 2000, imageLink: "sheeshtawoog.jpg"),
  Spiecies(name: "سمك", type: "meat", price: 1800, imageLink: "fish.jpg"),
  Spiecies(name: "اقاشي", type: "meat", price: 1500, imageLink: "agashi.jpg"),
  Spiecies(name: "بيرقر", type: "meat", price: 1400, imageLink: "burger.jpg"),
  Spiecies(name: "بوفتيك", type: "meat", price: 1000, imageLink: "bufftake.jpg"),

];
List<Spiecies> toppings = [
  Spiecies(name: "جبنة", type: "topping", price: 300, imageLink: "cheese-topping.jpg"),
  Spiecies(name: "بيض باللحمة", type: "topping", price: 300, imageLink: "egg-meat-topping.jpg"),
  Spiecies(name: "شيبس ", type: "topping", price: 200, imageLink: "fries-topping.jpg"),
  Spiecies(name: "بيض", type: "topping", price: 200, imageLink: "egg -topping.jpg"),
  Spiecies(name: "فول ", type: "topping", price: 100, imageLink: "fool-topping.jpg"),
  Spiecies(name: "فطيرة", type: "topping", price: 100, imageLink: "fatera.jpg"),
];

//get data mock from database

final int number_of_spiecies=  meat.length + traditional.length + juices.length + toppings.length;
List<Spiecies> All =   meat + traditional + toppings + juices;