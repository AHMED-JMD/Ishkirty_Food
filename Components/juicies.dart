import 'package:ashkerty_food/models/speicies.dart';
import 'package:ashkerty_food/static/GridBuilder.dart';
import 'package:flutter/material.dart';

class Juicies extends StatefulWidget {
  const Juicies({super.key});

  @override
  State<Juicies> createState() => _JuiciesState();
}

class _JuiciesState extends State<Juicies> {
  //mock get data from db

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
                  Text('العصائر',textAlign: TextAlign.right ,style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GridViewBuilder(data: juices,),
            ),
          ],
        )
    );
  }
}
