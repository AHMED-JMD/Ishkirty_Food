import 'dart:convert';
import 'package:ashkerty_food/Components/GridBuilder.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/widgets/SpeciesStats.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ashkerty_food/API/Sales.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../static/SalesCard.dart';
import 'Sales_Graphs.dart';
// import 'package:money_formatter/money_formatter.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  bool isLoading = false;
  int cashMor = 0;
  int bankMor = 0;
  int accountMor = 0;
  int totalMor = 0;
  int cashEv = 0;
  int bankEv = 0;
  int accountEv = 0;
  int totalEv = 0;

  List spieces = [];
  String period = 'اليوم';
  DateTime todayDate = DateTime.now();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    //initially get today's sales
    getSpiecesSales(todayDate, todayDate);
    getTotalSales(todayDate, todayDate);
    super.initState();
  }

  //search dates
  Future searchDates(datas) async {
    setState(() {
      isLoading = true;
    });

    //server call
    Map modDatas = {};
    modDatas['start_date'] = datas['start_date'];
    modDatas['end_date'] = datas['end_date'];

    final response = await APISales.TodaySales(modDatas);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      //check week or month before setting period
      String sPeriod = '';
      final int diffDays =
          DateTime.parse(datas['end_date']).difference(todayDate).inDays;

      if (diffDays == 7) {
        sPeriod = 'الإسبوع';
      } else if (diffDays == 30) {
        sPeriod = 'الشهر';
      } else {
        sPeriod = 'فترة زمنية';
      }

      setState(() {
        isLoading = false;
        cashMor = res["cashMor"].toInt();
        bankMor = res["bankMor"].toInt();
        accountMor = res["accountMor"].toInt();
        totalMor = res["totalMor"].toInt();
        cashEv = res["cashEv"].toInt();
        bankEv = res["bankEv"].toInt();
        accountEv = res["accountEv"].toInt();
        totalEv = res["totalEv"].toInt();
        period = sPeriod;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }

    // call total sales (pass DateTime objects, not strings)
    final DateTime startDt = DateTime.parse(datas['start_date']);
    final DateTime endDt = DateTime.parse(datas['end_date']);
    getSpiecesSales(startDt, endDt);
  }

  //get current dat
  Future getTotalSales(DateTime startDate, DateTime endDate) async {
    setState(() {
      isLoading = true;
    });

    //server call
    Map datas = {};
    datas['start_date'] = startDate.toIso8601String();
    datas['end_date'] = endDate.toIso8601String();
    final response = await APISales.TodaySales(datas);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        cashMor = res["cashMor"].toInt();
        bankMor = res["bankMor"].toInt();
        accountMor = res["accountMor"].toInt();
        totalMor = res["totalMor"].toInt();
        cashEv = res["cashEv"].toInt();
        bankEv = res["bankEv"].toInt();
        accountEv = res["accountEv"].toInt();
        totalEv = res["totalEv"].toInt();
        period = 'اليوم';
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  //get spieces sales
  Future getSpiecesSales(DateTime startDtae, DateTime endDate) async {
    setState(() {
      isLoading = true;
      spieces = [];
    });

    //server call
    Map data = {};
    data['start_date'] = startDtae.toIso8601String();
    data['end_date'] = endDate.toIso8601String();

    final response = await APISales.allSpeicesSales(data);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        spieces = res;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //getting the morning variables values

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
            child: Text("المبيعات",
                style: TextStyle(
                  fontSize: 25,
                )),
          ),
          actions: const [
            LeadingDrawerBtn(),
          ],
          toolbarHeight: 45,
        ),
        endDrawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SearchInDates(searchDates: searchDates),
              if (isLoading)
                const SpinKitCircle(
                  color: Colors.black45,
                  size: 50,
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'إجمالي الإيرادات $period',
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(
                        "${numberFormatter(totalMor + totalEv)} / (جنيه) ",
                        style: const TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 330,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SalesCard(
                          period: 'الوردية الصباحية',
                          cashAmount: cashMor,
                          bankakAmount: bankMor,
                          accountsAmount: accountMor,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 330,
                        decoration: BoxDecoration(
                          color: const Color(0xffefecec),
                          border: Border.all(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SalesCard(
                          period: 'الوردية المسائية',
                          cashAmount: cashEv,
                          bankakAmount: bankEv,
                          accountsAmount: accountEv,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 90,
              ),
              const Text(
                'الإيرادات بالصنف',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 20,
              ),
              spieces.isNotEmpty
                  ? Center(
                      child: GridViewBuilder(
                      data: spieces,
                      flag: "sales",
                    ))
                  : const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: SpinKitCubeGrid(
                        color: Colors.teal,
                      ),
                    )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 65,
          color: const Color(0xffefecec),
          child: OverflowBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SalesGRaphs(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.auto_graph,
                  color: Color(0xffffffff),
                ),
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: FormBuilder(
                  key: _formKey,
                  child: FormBuilderTextField(
                    name: 'name',
                    validator: FormBuilderValidators.required(errorText: '*'),
                    decoration: InputDecoration(
                        labelText: 'اسم الصنف',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.saveAndValidate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpeciesStats(
                                          name: _formKey
                                              .currentState!.value['name'])));
                            }
                          },
                          icon: const Icon(Icons.search),
                        )),
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(
                  Icons.menu,
                  size: 36,
                ),
                onSelected: (value) {},
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'week',
                      onTap: () {
                        // Get the date of a week before the current date
                        DateTime weekBeforeDate =
                            todayDate.subtract(const Duration(days: 7));

                        //for total sales
                        getTotalSales(weekBeforeDate, todayDate);
                        //for spieces sales
                        getSpiecesSales(weekBeforeDate, todayDate);
                      },
                      child: const Text(
                        'إيرادات الإسبوع',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'month',
                      onTap: () {
                        // Get the date of a week before the current date
                        DateTime monthBeforeDate =
                            todayDate.subtract(const Duration(days: 30));
                        //for total sales
                        getTotalSales(monthBeforeDate, todayDate);
                        //for spieces sales
                        getSpiecesSales(monthBeforeDate, todayDate);
                      },
                      child: const Text(
                        'إيرادات الشهر',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'day',
                      onTap: () => getTotalSales(todayDate, todayDate),
                      child: const Text(
                        'إيرادات اليوم',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
