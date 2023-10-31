import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/models/speicies.dart';
import 'package:ashkerty_food/static/GridBuilder.dart';
import 'package:flutter/material.dart';

class Traditional extends StatefulWidget {
  final List traditional;
  const Traditional({super.key, required this.traditional});

  @override
  State<Traditional> createState() => _TraditionalState(traditional: traditional);
}

class _TraditionalState extends State<Traditional> {
  final List traditional;
  _TraditionalState({required this.traditional});

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
                  Text('تقليدي',textAlign: TextAlign.right ,style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GridViewBuilder(data: traditional,),
            )
          ],
        )
    );
  }
}
