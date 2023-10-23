import 'package:ashkerty_food/widgets/Bills.dart';
import 'package:flutter/material.dart';
import '../Components/tables/SalesTable.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';
class  BillDeatles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff20491a),
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
                  builder: (context) => const Bills(),
                ),
              );
            },
          ),
          title: const Center(child:Text(" تفاصيل الفاتورة", style: TextStyle(fontSize: 25,)),),
          actions: const [LeadingDrawerBtn(),],

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
                  const SizedBox(height: 20,),
                  Container(
                      color: Colors.grey[100],
                      child: SalesTable(data: [],)
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
