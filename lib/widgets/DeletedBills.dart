import 'dart:convert';
import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/dropDownBtn.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Components/tables/DeletedBillsTable.dart';

class DeletedBills extends StatefulWidget {
  const DeletedBills({super.key});

  @override
  State<DeletedBills> createState() => _DeletedBillsState();
}

class _DeletedBillsState extends State<DeletedBills> {
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
    DateTime now = DateTime.now();
    Map datas = {};
    datas['isDeleted'] = true;
    datas['todayDate'] = '${now.year}-${now.month}-${now.day}';

    final response = await APIBill.GetAll(datas,);

    if(response.statusCode == 200){
      var res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }
  // //search dates
  Future searchDates(datas) async {
    setState(() {
      isLoading = true;
      data = [];
    });

    //server call
    Map mod_datas = {};
    mod_datas['start_date'] = datas['start_date'];
    mod_datas['end_date'] = datas['end_date'];
    mod_datas['isDeleted'] = true;

    final response = await APIBill.Search(mod_datas);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          //custom button in static folder
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 37,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/bills');
            },
          ),
          title: const Center(
              child: Text(
            "الفواتير المحذوفة",
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
              const SizedBox(
                height: 90,
              ),
              //custom widget in static folder for showing search bar responsive
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SearchInDates(
                    searchDates: searchDates,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: MyDropdownButton(searchDates: searchDates),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              data.length != 0 || isLoading == false
                  ? Container(
                      color: Colors.grey[100],
                      child: DeletedBillsTable(
                        data: data,
                      ))
                  : Padding(
                      padding: const EdgeInsets.only(top: 190.0),
                      child: SpinKitPouringHourGlassRefined(
                        color: Colors.teal,
                        size: 70.0,
                      ),
                    ),
            ],
          ),
        ]),
      ),
    );
  }
}
