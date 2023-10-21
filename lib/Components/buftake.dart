import 'package:ashkerty_food/models/speicies.dart';
import 'package:ashkerty_food/static/GridBuilder.dart';
import 'package:flutter/material.dart';

class BufTakes extends StatefulWidget {
  const BufTakes({super.key});

  @override
  State<BufTakes> createState() => _BufTakesState();
}

class _BufTakesState extends State<BufTakes> {

  //get data mock from database

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: Row(
                children: [
                  Text('البفتيك: ',textAlign: TextAlign.right ,style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GridViewBuilder(data: toppings,),
            ),
          ],
        )
    );
  }
}
