import 'dart:convert';

import 'package:ashkerty_food/API/Sales.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/SpicesStats_Card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';

class SpeciesStats extends StatefulWidget {
  final String name;
  const SpeciesStats({super.key, required this.name});

  @override
  State<SpeciesStats> createState() => _SpeciesStatsState();
}

class _SpeciesStatsState extends State<SpeciesStats> {
  int total_day = 0;
  int total_week = 0;
  int total_month = 0;
  int total_searched = 0;
  DateTime today_date = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getSpeicesSales();
    super.initState();
  }

  //get current date sales
  Future getSpeicesSales() async {
    setState(() {
      isLoading = true;
    });

    //server call
    Map datas = {};
    DateTime monthBeforeDate = today_date.subtract(Duration(days: 30));
    DateTime weekBeforeDate = today_date.subtract(Duration(days: 7));

    datas['name'] = widget.name;
    datas['curr_date'] = today_date.toIso8601String();
    datas['week_date'] = weekBeforeDate.toIso8601String();
    datas['month_date'] = monthBeforeDate.toIso8601String();

    final response = await APISales.SpeicesSales(datas);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        total_day = res['total_day_sales'];
        total_week = res['total_week_sales'];
        total_month = res['total_month_sales'];
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  //searched sales
  //search dates
  Future searchSales(datas) async {
    setState(() {
      isLoading = true;
    });

    //server call
    Map mod_datas = {};
    mod_datas['name'] = widget.name;
    mod_datas['start_date'] = datas['start_date'];
    mod_datas['end_date'] = datas['end_date'];

    final response = await APISales.SearchedSales(mod_datas);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        total_searched = res['total_searched_sales'];
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
            backgroundColor: const Color(0xff20491a),
            //custom button in static folder
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 37,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/orders');
              },
            ),

            title: Center(
                child: Text(
              "مبيعات ${widget.name}",
              style: TextStyle(fontSize: 25),
            )),
            actions: const [
              LeadingDrawerBtn(),
            ],
            toolbarHeight: 45,
          ),
          //custom my drawer in static folder
          endDrawer: const MyDrawer(),
          body: isLoading
              ? Center(
                  child: Container(
                    width: 300,
                    height: 100,
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الرجاء الانتظار لحظات',
                          style: TextStyle(fontSize: 20),
                        ),
                        SpinKitThreeInOut(
                          color: Colors.green,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      SearchInDates(searchDates: searchSales),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SpiecesCard(title: 'مبيعات اليوم', total: total_day),
                          SpiecesCard(
                              title: 'مبيعات الاسبوع', total: total_week),
                          SpiecesCard(
                              title: 'مبيعات الشهر', total: total_month),
                          SpiecesCard(
                              title: 'مبيعات خلال فترة البحث',
                              total: total_searched),
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AspectRatio(
                          aspectRatio: 4,
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.grey[300],
                            child: BarChart(BarChartData(
                                alignment: BarChartAlignment.center,
                                borderData: FlBorderData(
                                    border: const Border(
                                  top: BorderSide.none,
                                  right: BorderSide.none,
                                  left: BorderSide(width: 1),
                                  bottom: BorderSide(width: 1),
                                )),
                                groupsSpace: 100,
                                barTouchData: BarTouchData(enabled: true),
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            String text = '';

                                            switch (value.toInt()) {
                                              case 1:
                                                text = 'مبيعات اليوم';
                                                break;
                                              case 2:
                                                text = 'مبيعات الاسبوع';
                                                break;
                                              case 3:
                                                text = 'مبيعات الشهر';
                                                break;
                                              case 4:
                                                text = 'مبيعات فترة البحث';
                                                break;
                                            }
                                            return Text(text);
                                          })),
                                ),
                                barGroups: [
                                  BarChartGroupData(x: 1, barRods: [
                                    BarChartRodData(
                                        toY: total_day.toDouble(),
                                        width: 30,
                                        color: Colors.green),
                                  ]),
                                  BarChartGroupData(x: 2, barRods: [
                                    BarChartRodData(
                                        toY: total_week.toDouble(),
                                        width: 30,
                                        color: Colors.green),
                                  ]),
                                  BarChartGroupData(x: 3, barRods: [
                                    BarChartRodData(
                                        toY: total_month.toDouble(),
                                        width: 30,
                                        color: Colors.green),
                                  ]),
                                  BarChartGroupData(x: 4, barRods: [
                                    BarChartRodData(
                                        toY: total_searched.toDouble(),
                                        width: 30,
                                        color: Colors.green),
                                  ]),
                                ])),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )),
    );
  }
}
