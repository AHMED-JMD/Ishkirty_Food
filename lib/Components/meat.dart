import 'package:ashkerty_food/static/GridBuilder.dart';
import 'package:flutter/material.dart';

class Meat extends StatefulWidget {
  final List meat;
  const Meat({super.key, required this.meat});

  @override
  State<Meat> createState() => _MeatState(meat: meat);
}

class _MeatState extends State<Meat> {
  final List meat;
  _MeatState({required this.meat});

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
                  Text('اللحوم',textAlign: TextAlign.right ,style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GridViewBuilder(data: meat,),
            )
          ],
        )
    );
  }
}
