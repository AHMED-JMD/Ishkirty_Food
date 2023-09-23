import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: LeadingDrawerBtn(),
          title: Text("العملاء", style: TextStyle(fontSize: 25),),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Text('clients'),
        ),
      ),
    );
  }
}
