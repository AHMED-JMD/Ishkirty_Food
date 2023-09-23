import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

class Speices extends StatefulWidget {
  const Speices({super.key});

  @override
  State<Speices> createState() => _SpeicesState();
}

class _SpeicesState extends State<Speices> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: LeadingDrawerBtn(),
          title: Text("الاصناق", style: TextStyle(fontSize: 25),),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Text('spieces'),
        ),
      ),
    );
  }
}
