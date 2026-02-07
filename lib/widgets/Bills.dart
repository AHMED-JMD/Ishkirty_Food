import 'dart:convert';
import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/Components/tables/BillTable.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/dropDownBtn.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/widgets/DeletedBills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

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
  Future getBills() async {
    setState(() {
      isLoading = true;
    });

    //call server
    DateTime now = DateTime.now();
    Map dataBody = {};
    dataBody['isDeleted'] = false;
    dataBody['todayDate'] = '${now.year}-${now.month}-${now.day}';

    final response = await APIBill.GetAll(dataBody);

    final datas = jsonDecode(response.body);

    setState(() {
      isLoading = false;
      data = datas;
    });
  }

  //search dates
  Future searchDates(datas) async {
    setState(() {
      isLoading = true;
      data = [];
    });

    //server call
    Map mod_datas = {};
    mod_datas['start_date'] = datas['start_date'];
    mod_datas['end_date'] = datas['end_date'];
    mod_datas['isDeleted'] = false;

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
    return Consumer<AuthProvider>(builder: (context, value, child) {
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
                const SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SearchInDates(searchDates: searchDates),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: MyDropdownButton(searchDates: searchDates),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        value.user != null && value.user['role'] == 'admin'
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DeletedBills(),
                                    ),
                                  );
                                },
                                label: const Text(
                                  'الفواتير المحذوفة',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal),
                                icon: const Icon(
                                  Icons.delete_forever_outlined,
                                  size: 30,
                                  color: Colors.black,
                                ))
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                data.isNotEmpty || isLoading == false
                    ? Container(
                        color: Colors.grey[100],
                        child: billTable(
                          data: data,
                        ))
                    : const Padding(
                        padding: EdgeInsets.only(top: 190.0),
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
    });
  }
}
