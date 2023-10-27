import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import '../static/SalesCard.dart';
import 'Sales_Graphs.dart';
class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff20491a),
            leading:  IconButton(
                icon: const Icon(
                  Icons.home,
                  size: 37,
                  color: Colors.white,
                ),
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),

            title: const Center(child:Text("المبيعات اليومية", style: TextStyle(fontSize: 25,)),),
          actions: const [LeadingDrawerBtn(),],
          toolbarHeight: 45,
        ),
        endDrawer: const MyDrawer(),
        body:SingleChildScrollView(
        child:Column(
          children: [
            const SizedBox(height: 10,),
            const Text('إجمالي الإيرادات لليوم',style: TextStyle(fontSize: 30),),
            const Text('695,000',style: TextStyle(fontSize: 30),),
            const SizedBox(height: 10,),
            Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffefecec),
                    border: Border.all(
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
               child: SalesCard(Period: 'إيرادات الوردية الصباحية',CashAmount: 540000,BankakAmount: 15000,AccountsAmount: 4000,),),
              const SizedBox(height: 25,),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffefecec),
                border: Border.all(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(0),
              ),
               child: SalesCard(Period: 'إيرادات الوردية المسائية',CashAmount: 100000,BankakAmount: 20000,AccountsAmount: 16000,),),
          ],
        ),
        ),
bottomNavigationBar:   BottomAppBar(
  height: 60,
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
        SizedBox(width: 300,height: 100,
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),

            decoration:  InputDecoration(
              labelText: "الصنف",
              labelStyle: const TextStyle(color: Colors.black,fontSize: 24),
//border: UnderlineInputBorder(),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                  icon:const Icon(Icons.search_sharp,size: 25,color: Colors.black87,),
                onPressed: () {  },


              )
            ),

          ),
        ),
    PopupMenuButton(icon:Icon(Icons.menu,size: 36,),
      onSelected: (value){

      },
      itemBuilder: (BuildContext context) { return[
      PopupMenuItem(child:  Text('إيرادات الإسبوع', style: TextStyle(fontSize: 20,color: Colors.black),),value: 'week',),
      PopupMenuItem(child:  Text('إيرادات الشهر', style: TextStyle(fontSize: 20,color: Colors.black),),value: 'month',),
      PopupMenuItem(child:  Text('إيرادات السنة', style: TextStyle(fontSize: 20,color: Colors.black),),value: 'year',),

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
