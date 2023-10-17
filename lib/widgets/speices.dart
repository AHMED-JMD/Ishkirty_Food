import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';

import '../Components/tables/SpieciesTable.dart';
import '../models/speicies.dart';

class Speices extends StatefulWidget {
  const Speices({super.key});

  @override
  State<Speices> createState() => _SpeicesState();
}

class _SpeicesState extends State<Speices> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xff083434),
          leading: IconButton(
            icon: const Icon(
              Icons.home_sharp,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          title: const Center(child: Text("الاصناف", style: TextStyle(fontSize: 25),)),
        actions: const [LeadingDrawerBtn(),],
        ),
        endDrawer: const MyDrawer(),
        body:ListView(
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
                      child: SpeiciesTable(data: [],)
                  ),
                ],
              ),
            ]
        ),
        bottomNavigationBar: BottomAppBar(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('عدد الاصناف=$number_of_spiecies',style: const TextStyle(fontSize: 24),),],
          ),
        ),
      ),

    );
  }
}
