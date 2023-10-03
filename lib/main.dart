import 'package:ashkerty_food/widgets/Home.dart';
import 'package:ashkerty_food/widgets/Login.dart';
import 'package:ashkerty_food/widgets/clients.dart';
import 'package:ashkerty_food/widgets/orders.dart';
import 'package:ashkerty_food/widgets/sales.dart';
import 'package:ashkerty_food/widgets/speices.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
        // '/': (context) => Login(),
        '/' : (context) => MyHomePage(),
        '/orders' : (context) => Orders(),
        '/sales' : (context) => Sales(),
        '/speices' : (context) => Speices(),
        '/clients' : (context) => Clients(),
      },
    );
  }
}


