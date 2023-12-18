import 'dart:convert';

import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/Components/tables/BillTable.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  const Bills({super.key});

  @override
  State<Bills> createState() => _BillsState();
}

class _BillsState extends State<Bills> {
  List data = [];
  bool isLoading = false;

  @override
  void initState() {
    getBills();
    super.initState();
  }

  //server func to get bills
  Future getBills () async {
    setState(() {
      isLoading = true;
      data = [];
    });
    //get from server
    final response = await APIBill.GetAll();

    if(response.statusCode == 200){
      var res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
      });
    }
    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    print(data);
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
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          title: const Center(child: Text("الفواتير", style: TextStyle(fontSize: 25),)),
          actions: const [LeadingDrawerBtn(),],
          toolbarHeight: 45,
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
                  data.length != 0?
                  Container(
                    color: Colors.grey[100],
                      child: billTable(data: data,)
                  ) : Container(
                      child: billTable(data: data,)
                  ) ,
                ],
              ),
            ]
          ),

      ),
    );
  }
}
