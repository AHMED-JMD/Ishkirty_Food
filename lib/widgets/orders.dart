import 'dart:convert';
import 'package:ashkerty_food/widgets/SpeciesStats.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/API/Sales.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../static/SalesCard.dart';
import 'Sales_Graphs.dart';
import 'package:money_formatter/money_formatter.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool isLoading = false;
  List data = [];
  List spices = [];
  String period = 'اليوم';
  DateTime today_date = DateTime.now();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();


  @override
  void initState() {
    // TODO: implement initState
    getTodaySales();
    super.initState();
  }

  //search dates
  Future searchDates (datas) async {
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
    if(response.statusCode == 200){
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
        period = 'فترة زمنية';
      });
    } else{
      setState(() {
        isLoading = false;
      });
    }
  }
  //get current dat
  Future getTodaySales () async {
    setState(() {
      isLoading = true;
      data = [];
    });

    //server call
    Map datas = {};
    datas['curr_date'] = today_date.toIso8601String();
    final response = await APISales.TodaySales(datas);
    //response validity
    if(response.statusCode == 200){
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
        period = 'اليوم';
      });
    } else{
      setState(() {
        isLoading = false;
      });
    }
  }

  //dart function to get sums
  num calculateSum(List data, String paymentMethod, String shiftTime) {
    num sum = 0;
    for (var item in data) {
      if (item["paymentMethod"] == paymentMethod && item['shiftTime'] == shiftTime) {
        sum += item["amount"] ?? 0;
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    //getting the morning variables values
    num totalMor = calculateSum(data, "كاش", "صباحية") +
        calculateSum(data, "بنكك", "صباحية") +
        calculateSum(data, "حساب", "صباحية");

    num cashMor = calculateSum(data, "كاش", "صباحية");
    num bankMor = calculateSum(data, "بنكك", "صباحية");
    num accountMor = calculateSum(data, "حساب", "صباحية");
    //getting the variables values
    num totalEv = calculateSum(data, "كاش", "مسائية") +
        calculateSum(data, "بنكك", "مسائية") +
        calculateSum(data, "حساب", "مسائية");

    num cashEv = calculateSum(data, "كاش", "مسائية");
    num bankEv = calculateSum(data, "بنكك", "مسائية");
    num accountEv = calculateSum(data, "حساب", "مسائية");

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
            leading:  IconButton(
                icon: const Icon(
                  Icons.home_work,
                  size: 37,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),

            title: const Center(child:Text("المبيعات", style: TextStyle(fontSize: 25,)),),
          actions: const [LeadingDrawerBtn(),],
          toolbarHeight: 45,
        ),
        endDrawer: const MyDrawer(),

        body: SingleChildScrollView(
          child:Column(
            children: [
              SearchInDates(searchDates: searchDates ),
              if(isLoading)
                SpinKitCircle(
                  color: Colors.black45,
                  size: 50,
                ),
              const SizedBox(height: 30,),
              const Text('إجمالي الإيرادات لليوم',style: TextStyle(fontSize: 30),),
              Text(
                '${MoneyFormatter(amount: totalEv.toDouble() + totalMor.toDouble()).output.withoutFractionDigits}'
                ,style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 500,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    child: SalesCard(
                      Period: 'إيرادات الوردية الصباحية',
                      CashAmount: cashMor.toInt(),
                      BankakAmount: bankMor.toInt(),
                      AccountsAmount: accountMor.toInt(),
                      period: period,
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                      color: const Color(0xffefecec),
                      border: Border.all(
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SalesCard(
                      Period: 'إيرادات الوردية المسائية',
                      CashAmount: cashEv.toInt(),
                      BankakAmount: bankEv.toInt(),
                      AccountsAmount: accountEv.toInt(),
                      period: period,
                    ),
                  ),
                ],
              ),

          ],
        ),
        ),
        bottomNavigationBar:   BottomAppBar(
          height: 65,
          color: const Color(0xffefecec),

          child:ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
                FilledButton(
                  onPressed: () { Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalesGRaphs(),
                    ),
                  );},
                  child: const Icon(Icons.auto_graph,color: Color(0xffffffff),),
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: FormBuilder(
                    key: _formKey,
                    child: FormBuilderTextField(
                      name: 'name',
                      validator: FormBuilderValidators.required(errorText: '*'),
                      decoration:  InputDecoration(
                        labelText: 'اسم الصنف',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: (){
                            if(_formKey.currentState!.saveAndValidate()){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SpeciesStats(name: _formKey.currentState!.value['name'])
                              )
                              );
                            }
                          },
                          icon: Icon(Icons.search),
                        )
                      ),
                    ),

                  ),
                ),
            PopupMenuButton(
              icon:Icon(Icons.menu,size: 36,),
              onSelected: (value){

              },
              itemBuilder: (BuildContext context) {
                return[
                        PopupMenuItem(
                          child:  InkWell(
                            onTap: (){
                              // Get the date of a week before the current date
                              DateTime weekBeforeDate = today_date.subtract(Duration(days: 7));

                              //call server
                              Map datas = {};
                              datas['start_date'] = weekBeforeDate.toIso8601String();
                              datas['end_date'] = today_date.toIso8601String();
                              datas['isDeleted'] = false;

                              searchDates(datas);
                            },
                              child: Text('إيرادات الإسبوع', style: TextStyle(fontSize: 20,color: Colors.black),)),
                          value: 'week',
                        ),
                        PopupMenuItem(
                          child:  InkWell(
                              onTap:() {
                                // Get the date of a week before the current date
                                DateTime monthBeforeDate = today_date.subtract(Duration(days: 30));

                                //call server
                                Map datas = {};
                                datas['start_date'] = monthBeforeDate.toIso8601String();
                                datas['end_date'] = today_date.toIso8601String();
                                datas['isDeleted'] = false;

                                searchDates(datas);
                              } ,
                              child: Text('إيرادات الشهر', style: TextStyle(fontSize: 20,color: Colors.black),)),
                          value: 'month',
                        ),
                        PopupMenuItem(
                          child:  InkWell(
                              onTap: (){
                                getTodaySales();
                              },
                              child: Text('إيرادات اليوم', style: TextStyle(fontSize: 20,color: Colors.black),)),
                          value: 'year',
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
