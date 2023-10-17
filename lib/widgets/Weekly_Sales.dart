import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

import '../static/SalesCard.dart';
class WeeklySales extends StatefulWidget {
  const WeeklySales({super.key});

  @override
  State<WeeklySales> createState() => _WeeklySales();
}

class _WeeklySales extends State<WeeklySales> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff083434),
          leading:  IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 37,
              color: Color(0xffffffff),
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/orders');
            },
          ),
          title: const Center(child:Text("مبيعات الإسبوع", style: TextStyle(fontSize: 25,)),),
          actions: const [LeadingDrawerBtn(),],

        ),
        endDrawer: const MyDrawer(),
        body:
         Column(
          children: [
            const SizedBox(height: 20,),
           const Text('إجمالي الإيرادات للإسبوع',style: TextStyle(fontSize: 30),),
            const Text('1,000,000',style: TextStyle(fontSize: 30),),
            const SizedBox(height: 40,),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffefecec),
                border: Border.all(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SalesCard(Period: 'إيرادات الوردية الصباحية',CashAmount: 540000,BankakAmount: 15000,AccountsAmount: 4000,),),
            const SizedBox(height: 100,),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffefecec),
                border: Border.all(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SalesCard(Period: 'إيرادات الوردية المسائية',CashAmount: 100000,BankakAmount: 20000,AccountsAmount: 16000,),),

          ],
        ),





      ),


    );
  }
}
