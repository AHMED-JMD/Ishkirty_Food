import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/models/kebordKeys.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/Components/Forms/CartForm.dart';
import 'package:ashkerty_food/widgets/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keymap/keymap.dart';
import 'package:flutter/services.dart';
import 'package:ashkerty_food/models/cart_model.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List favSpieces = [];

  @override
  void initState() {
    getFavs();
    super.initState();
  }

  //server function to get favourites
  Future getFavs() async {
    //call server
    final res = await APISpieces.GetFavs();

    if(res != false){
      setState(() {
        favSpieces = res;
      });
    }
  }

  //custom cart widget
  Widget _cart(BuildContext context, item, cartProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width/3.5,
            child: Card(
              color: Colors.grey[100],
              elevation: 3,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "${item.spices} : ${item.unit_price}",
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //delete from cart provider
                          cartProvider.deletefromCart(item);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "الكمية",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          //add amount
                          cartProvider.addAmount(item);
                        },
                        icon: Icon(
                          Icons.add_box,
                          color: Colors.teal,
                          size: 27,
                        ),
                        tooltip: 'إضافة',
                      ),
                      Text('${item.counter}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18)),
                      IconButton(
                        onPressed: () {
                          //decrease amount
                          cartProvider.minusAmount(item);
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.teal,
                          size: 27,
                        ),
                        tooltip: 'نقصان',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "السعر الكلي: ${item.total_price}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 21, color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardWidget(
      bindings: favSpieces.map((theKey) {
        LogicalKeyboardKey key = KeyBoardKeys[theKey['favBtn']] ?? LogicalKeyboardKey.f1;

        return KeyAction(
            key,
            'اضف ${theKey['name']} الى الفاتورة',
                () {
              //perform action here
              Cart model = Cart(
                  spices: theKey['name'],
                  counter: 1,
                  unit_price: theKey['price'],
                  total_price: theKey['price']);
              //add to provider
              final cartProvider = context.read<CartProvider>();
              cartProvider.addToCart(model);

              Navigator.pushNamed(context, '/cart');
            }, isControlPressed: theKey['isControll'] ?? false);
      }).toList(),
      child: Focus(
          autofocus: true,
          child: Consumer<CartProvider>(builder: (context, value, child) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.teal,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 37,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                    centerTitle: true,
                    title: Text('سلة الفواتير'),
                  ),
                  body: value.cart.length != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width/1.5,
                                  height: MediaQuery.of(context).size.height/1.2,
                                  color: Colors.grey[100],
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3
                                        ),
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: value.cart.length,
                                    itemBuilder: (context, index) {
                                      //current item
                                      var item = value.cart[index];
                                      var cartProvider =
                                          context.read<CartProvider>();
                                      //call cart widget and iterate
                                      return _cart(context, item, cartProvider);
                                    },
                                  ),
                                ),
                              ),
                              CartForm(),
                            ])
                      : Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.grey[200]),
                                label: Text(
                                  "Go",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 23,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.shopping_cart_checkout,
                                  color: Colors.teal,
                                  size: 30,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'سلة الفواتير فارغة قم باضافة اصناف ',
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                ));
          })),
    );
  }
}
