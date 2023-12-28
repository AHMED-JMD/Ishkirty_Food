import 'dart:convert';

import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/Components/tables/BillTable.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(
              Icons.home_work,
              size: 37,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          title: const Center(
              child: Text(
            "الفواتير",
            style: TextStyle(fontSize: 25),
          )),
          actions: const [
            LeadingDrawerBtn(),
          ],
          toolbarHeight: 45,
        ),

        //custom drawer in static folder
        endDrawer: const MyDrawer(),

        body: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 90,
              ),
              SizedBox(
                height: 10,
              ),
              Container(color: Colors.grey[100], child: billTable())
            ],
          ),
        ]),
      ),
    );
  }
}
