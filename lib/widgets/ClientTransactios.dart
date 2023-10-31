import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import '../Components/tables/ClientBillTable.dart';
import '../static/drawer.dart';

class ClientTransactios extends StatefulWidget {
  const ClientTransactios({super.key});

  @override
  State<ClientTransactios> createState() => _ClientTransactiosState();
}

class _ClientTransactiosState extends State<ClientTransactios> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xff20491a),
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
                  Container(
                      color: Colors.grey[100],
                      child: ClientBillTable(data: [],)
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
