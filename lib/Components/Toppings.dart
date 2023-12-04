import 'package:ashkerty_food/static/GridBuilder.dart';
import 'package:flutter/material.dart';

class Toppings extends StatefulWidget {
  final List toppings;
  Toppings({super.key, required this.toppings});

  @override
  State<Toppings> createState() => _ToppingsState(toppings: toppings);
}

class _ToppingsState extends State<Toppings> {
  final List toppings;
  _ToppingsState({required this.toppings});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 28.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('إضافات',textAlign: TextAlign.right ,style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GridViewBuilder(data: toppings,),
            )
          ],
        )
    );
  }
}
