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

    if (res != false) {
      setState(() {
        favSpieces = res;
      });
    }
  }

  //custom cart widget
  Widget _cart(BuildContext context, Cart item, cartProvider) {
    List<Widget> addonWidgets = [];

    if (item.addons.isNotEmpty) {
      addonWidgets = item.addons.map((add) {
        return Text(
          '$add + ',
          style: TextStyle(color: Colors.grey[600]),
        );
      }).toList();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 3.5,
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
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          //delete from cart provider
                          cartProvider.deletefromCart(item);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (item.addons.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [...addonWidgets],
                    ),
                  const Text(
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
                        icon: const Icon(
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
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "السعر الكلي: ${item.total_price}",
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 21, color: Colors.black),
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
        LogicalKeyboardKey key =
            KeyBoardKeys[theKey['favBtn']] ?? LogicalKeyboardKey.f1;

        return KeyAction(key, 'اضف ${theKey['name']} الى الفاتورة', () {
          //perform action here
          Cart model = Cart(
              spices: theKey['name'],
              counter: 1,
              category: theKey['category'],
              addons: [],
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
                    title: const Text('سلة الفواتير'),
                  ),
                  body: value.cart.length != 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  height:
                                      MediaQuery.of(context).size.height / 1.2,
                                  color: Colors.grey[100],
                                  child: LayoutBuilder(
                                    builder: (BuildContext context,
                                        BoxConstraints constraints) {
                                      if (constraints.maxWidth > 1400) {
                                        return GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 5),
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount: value.cart.length,
                                          itemBuilder: (context, index) {
                                            //current item
                                            var item = value.cart[index];
                                            var cartProvider =
                                                context.read<CartProvider>();
                                            //call cart widget and iterate
                                            return _cart(
                                                context, item, cartProvider);
                                          },
                                        );
                                      } else {
                                        return GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4),
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount: value.cart.length,
                                          itemBuilder: (context, index) {
                                            //current item
                                            var item = value.cart[index];
                                            var cartProvider =
                                                context.read<CartProvider>();
                                            //call cart widget and iterate
                                            return _cart(
                                                context, item, cartProvider);
                                          },
                                        );
                                      }
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
                                          builder: (context) =>
                                              const MyHomePage()));
                                },
                                label: const Text(
                                  "Go",
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 23,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.shopping_cart_checkout,
                                  color: Colors.teal,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
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
