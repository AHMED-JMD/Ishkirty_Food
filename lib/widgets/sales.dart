import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: LeadingDrawerBtn(),
          title: Text("المبيعات", style: TextStyle(fontSize: 25),),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Text('sales'),
        ),
      ),
    );
  }
}
