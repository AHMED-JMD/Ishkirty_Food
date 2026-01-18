import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/widgets/Cart.dart';
import 'package:ashkerty_food/widgets/DeletedBills.dart';
import 'package:ashkerty_food/widgets/Home.dart';
import 'package:ashkerty_food/widgets/Login.dart';
import 'package:ashkerty_food/widgets/Profile.dart';
import 'package:ashkerty_food/widgets/Store.dart';
import 'package:ashkerty_food/widgets/clients.dart';
import 'package:ashkerty_food/widgets/Employee.dart';
import 'package:ashkerty_food/widgets/Sales.dart';
import 'package:ashkerty_food/widgets/Bills.dart';
import 'package:ashkerty_food/widgets/speices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget _defaultHome = const Login();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          '/home': (context) => const MyHomePage(),
          '/profile': (context) => const UserProfile(),
          '/cart': (context) => const MyCart(),
          '/sales': (context) => const Sales(),
          '/store': (context) => const StorePage(),
          '/bills': (context) => const Bills(),
          '/del_bills': (context) => const DeletedBills(),
          '/speices': (context) => const Speices(),
          '/clients': (context) => const Clients(),
          '/employees': (context) => const EmployeePage(),
        },
      ),
    );
  }
}
