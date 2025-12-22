import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/widgets/Cart.dart';
import 'package:ashkerty_food/widgets/DeletedBills.dart';
import 'package:ashkerty_food/widgets/Home.dart';
import 'package:ashkerty_food/widgets/Login.dart';
import 'package:ashkerty_food/widgets/Profile.dart';
import 'package:ashkerty_food/widgets/clients.dart';
import 'package:ashkerty_food/widgets/orders.dart';
import 'package:ashkerty_food/widgets/Bills.dart';
import 'package:ashkerty_food/widgets/speices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget _defaultHome = Login();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
        ),
        routes: {
          '/': (context) => _defaultHome,
          '/home': (context) => MyHomePage(),
          '/profile': (context) => UserProfile(),
          '/cart': (context) => MyCart(),
          '/orders': (context) => Orders(),
          '/bills': (context) => Bills(),
          '/del_bills': (context) => DeletedBills(),
          '/speices': (context) => Speices(),
          '/clients': (context) => Clients(),
        },
      ),
    );
  }
}
