import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/models/speicies.dart';
import 'package:ashkerty_food/static/GridBuilder.dart';
import 'package:flutter/material.dart';

class Juicies extends StatefulWidget {
  final List juices;
  const Juicies({super.key, required this.juices});

  @override
  State<Juicies> createState() => _JuiciesState(juices: juices);
}

class _JuiciesState extends State<Juicies> {
  final List juices;
  _JuiciesState({required this.juices});

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
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GridViewBuilder(data: juices,),
            )
          ],
        )
    );
  }
}
