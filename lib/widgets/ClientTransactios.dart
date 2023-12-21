import 'dart:convert';

import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Components/tables/ClientBillTable.dart';
import '../static/drawer.dart';

class ClientTransactios extends StatefulWidget {
  final int clientId;
  ClientTransactios({super.key, required this.clientId});

  @override
  State<ClientTransactios> createState() => _ClientTransactiosState(clientId: clientId);
}

class _ClientTransactiosState extends State<ClientTransactios> {
  final int clientId;
  _ClientTransactiosState({ required this.clientId});

  bool isLoading = false;
  List data = [];

  @override
  void initState() {
    // TODO: implement initState
    getClientBills();
    super.initState();
  }

  //future server functions
  Future getClientBills() async {
    setState(() {
      isLoading = true;
      data = [];
    });
    //call api
    Map datas = {};
    datas['clientId'] = clientId;
    final response = await APIBill.GetClientBills(datas);

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
//custom button in static folder
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/clients');
            },
          ),

          title: const Center(child: Text("المعاملات", style: TextStyle(fontSize: 25),)),
          actions: const [LeadingDrawerBtn(),],
          toolbarHeight: 45,),
        //custom my drawer in static folder
        endDrawer: const MyDrawer(),

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
                  const SizedBox(height: 20,),
                  data.length != 0 || isLoading == false ?
                  Container(
                      color: Colors.grey[100],
                      child: ClientBillTable(data: data,)
                  ) : Padding(
                    padding: const EdgeInsets.only(top: 190.0),
                    child: SpinKitPouringHourGlassRefined(
                      color: Colors.teal,
                      size: 70.0,
                    ),
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
