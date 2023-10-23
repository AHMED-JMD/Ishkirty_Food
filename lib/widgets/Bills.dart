import 'package:ashkerty_food/Components/tables/BillTable.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime? start_date = DateTime.now();
  DateTime? end_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xff20491a),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //custom widget in static folder for showing search bar responsive
                  const SearchInDates(),

                  const SizedBox(height: 10,),
                  Container(
                    color: Colors.grey[100],
                      child: billTable(data: [],)
                  ),
                ],
              ),
            ]
          ),

      ),
    );
  }
}
