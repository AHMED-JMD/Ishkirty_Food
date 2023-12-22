import 'package:ashkerty_food/static/SpicesStats_Card.dart';
import 'package:flutter/material.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';

class  SpeciesStats extends StatelessWidget {
  const SpeciesStats({super.key});
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
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/orders');
              },
            ),

            title: const Center(child: Text("مبيعات صنف", style: TextStyle(fontSize: 25),)),
            actions: const [LeadingDrawerBtn(),],
            toolbarHeight: 45,),
          //custom my drawer in static folder
          endDrawer: const MyDrawer(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SpiecesCard(title: 'مبيعات اليوم', total: 30),
                    SpiecesCard(title: 'مبيعات الشهر', total: 400),
                    SpiecesCard(title: 'مبيعات السنة', total: 2100),
                  ],
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 30,),
                    Container(
                      width: 500,
                      height:250,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.rectangle,
                      ),
                      child: const Center(child: Text('GRAPH1-week 7points',style: TextStyle(color: Colors.white),)),
                    ),
                    const SizedBox(width: 30,),
                    Container(
                      width: 500,
                      height:250,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.rectangle,
                      ),
                      child: const Center(child: Text('GRAPH2 month 4 points',style: TextStyle(color: Colors.white),)),
                    ),
                  ],
                ),
                const SizedBox(height:30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 500,
                      height:250,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.rectangle,
                      ),
                      child: const Center(child: Text('GRAPH3 year 12 points',style: TextStyle(color: Colors.white),)),
                    ),
                  ],
                ),

              ],
            ),
          )
      ),
    );
  }
}

