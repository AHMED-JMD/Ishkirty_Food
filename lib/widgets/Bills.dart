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
        appBar: AppBar(backgroundColor: const Color(0xff083434),
          //custom button in static folder
          leading: IconButton(
            icon: const Icon(
              Icons.home_sharp,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          title: const Center(child: Text("الفواتير", style: TextStyle(fontSize: 25),)),
          actions: const [LeadingDrawerBtn(),],
        ),

        //custom drawer in static folder
        endDrawer: const MyDrawer(),

        body: ListView(
            children:[
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100]
                  ),
                ),

              const SizedBox(height: 100,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //custom widget in static folder for showing search bar responsive
                  const SearchInDates(),

                  const SizedBox(height: 20,),
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
