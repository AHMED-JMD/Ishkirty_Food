import 'dart:convert';
import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/widgets/Bills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Components/tables/SalesTable.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';

class  BillDetailes extends StatefulWidget {
  final billId;
  BillDetailes({super.key, required this.billId});

  @override
  State<BillDetailes> createState() => _BillDetailesState(billId: billId);
}

class _BillDetailesState extends State<BillDetailes> {
  final billId;
  _BillDetailesState({required this.billId});

  @override
  void initState() {
    // TODO: implement initState
    getBilltrans();
    super.initState();
  }

  List data = [];
  bool isLoading = false;

  //server func to get bills
  Future getBilltrans () async {
    setState(() {
      isLoading = true;
      data = [];
    });
    //get from server
    Map datas = {};
    datas['billId'] = billId;
    final response = await APIBill.GetBillTrans(datas);

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200){
      var res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading:  IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  Bills(),
                ),
              );
            },
          ),
          title: const Center(child:Text(" تفاصيل الفاتورة", style: TextStyle(fontSize: 25,)),),
          actions: const [LeadingDrawerBtn(),],
        toolbarHeight: 45,
        ),
        endDrawer:const MyDrawer(),
        body: ListView(
            children:[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100]
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //custom widget in static folder for showing search bar responsive
                  const SizedBox(height: 60,),
                  data.length !=0 && isLoading == false ?
                  Container(
                      color: Colors.grey[100],
                      child: SalesTable(data: data,)
                  ) : SpinKitPouringHourGlassRefined(
                    color: Colors.teal,
                    size: 80.0,
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
