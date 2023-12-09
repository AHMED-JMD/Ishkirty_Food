import 'package:ashkerty_food/Components/tables/SalesTable.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime? start_date = DateTime.now();
  DateTime? end_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          //custom button in static folder
          leading: LeadingDrawerBtn(),

          backgroundColor: Colors.teal,
          title: Text("المبيعات", style: TextStyle(fontSize: 25),),
          toolbarHeight: 45, ),

        //custom drawer in static folder
        drawer: MyDrawer(),

        body: ListView(
          children:[
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100]
              ),
              child: Center(
                child: Text(
                  'مبيعات النظام',
                  style: TextStyle(fontSize: 30, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 100,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //custom widget in static folder for showing search bar responsive
                SearchInDates(),

                SizedBox(height: 20,),
                Container(
                  color: Colors.grey[100],
                    child: SalesTable(data: [],)
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
