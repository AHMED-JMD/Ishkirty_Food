import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/Components/Forms/CartForm.dart';
import 'package:ashkerty_food/models/cart_model.dart';
import 'package:ashkerty_food/models/kebordKeys.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/static/CartButton.dart';
import 'package:ashkerty_food/static/CheckTime.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/Components/menu_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../static/HomeDrawerbut.dart';
import 'package:flutter/services.dart';
import 'package:keymap/keymap.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

          Navigator.pushReplacementNamed(context, '/cart');
        }, isControlPressed: theKey['isControll'] ?? false);
      }).toList(),
      child: Focus(
        autofocus: true,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                  //custom button in folder static
                  leading: IconButton(
                    icon: Icon(
                      Icons.home_work,
                      size: 37,
                      color: Colors.grey.shade700,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  toolbarHeight: MediaQuery.of(context).size.height / 9.5,
                  title: const Text("YOUR LOGO"),
                  // title: Image.asset(
                  //   "assets/images/ef2.jpg",
                  //   height: MediaQuery.of(context).size.height / 9.5,
                  // ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: const [
                    CheckTime(),
                    SizedBox(
                      width: 20,
                    ),
                    HomeDrawerbut(),
                  ]),
              //custom drawer in static folder
              endDrawer: const MyDrawer(),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      //custom nav in component folder
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: ListView(children: const [Menu_Nav()]),
                          )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 1.1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: CartForm(),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: const CartButton()),
        ),
      ),
    );
  }
}
