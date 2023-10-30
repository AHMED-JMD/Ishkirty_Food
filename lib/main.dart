import 'package:ashkerty_food/widgets/Home.dart';
import 'package:ashkerty_food/widgets/Login.dart';
import 'package:ashkerty_food/widgets/clients.dart';
import 'package:ashkerty_food/widgets/orders.dart';
import 'package:ashkerty_food/widgets/Bills.dart';
import 'package:ashkerty_food/widgets/speices.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',

      ),
      routes: {
        //on development mode !--- when on production change default "/" to Login() widget ---!
        // and change MyHomePage() widget to "/home"
        '/': (context) =>  Login(),
        '/home' : (context) => const MyHomePage(),
        '/orders' : (context) => const Orders(),
        '/bills' : (context) => const Bills(),
        '/speices' : (context) => const Speices(),
        '/clients' : (context) => const Clients(),
      },
    );
  }
}