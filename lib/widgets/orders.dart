import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: LeadingDrawerBtn(),
          title: Text("الطلبات", style: TextStyle(fontSize: 25),),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Text('orders'),
        ),
      ),
    );
  }
}
