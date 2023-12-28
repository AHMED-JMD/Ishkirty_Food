import 'package:ashkerty_food/models/cart_model.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/static/CartButton.dart';
import 'package:ashkerty_food/static/CheckTime.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/spieces_nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Forms/TransactForm.dart';
import '../static/HomeDrawerbut.dart';
import 'package:flutter/services.dart';
import 'package:keymap/keymap.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return KeyboardWidget(
      bindings: [
        KeyAction(
          LogicalKeyboardKey.f2,
          'اضف بيرقر الى الفاتورة',
          () {
            // Perform your action here
            Cart model = Cart(
                spices: 'burger',
                counter: 1,
                unit_price: 1300,
                total_price: 1300);
            //add to provider
            final cartProvider = context.read<CartProvider>();
            cartProvider.addToCart(model);

            Navigator.pushNamed(context, '/cart');
          },
        ),
        KeyAction(LogicalKeyboardKey.keyF, 'اضف فول الى الفاتورة', () {
          // Perform your action here
          Cart model = Cart(
              spices: 'fool', counter: 1, unit_price: 800, total_price: 800);
          //add to provider
          final cartProvider = context.read<CartProvider>();
          cartProvider.addToCart(model);

          Navigator.pushNamed(context, '/cart');
        }, isControlPressed: true),
      ],
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
                  toolbarHeight: 70,
                  title: Image.asset(
                    "assets/images/ef1.jpg",
                    width: 100,
                    height: 80,
                  ),
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    CheckTime(),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 77,
                      height: 40,
                      child: FilledButton(
                        onPressed: () {
                          Transact(context);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey.shade600),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(color: Colors.transparent),
                            ))),
                        child: Text(
                          'تحويل',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
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
                      SizedBox(
                        height: 40,
                      ),
                      //custom nav in static folder
                      SpiecesNav(),
                    ],
                  ),
                ),
              ),
              floatingActionButton: CartButton()),
        ),
      ),
    );
  }
}
