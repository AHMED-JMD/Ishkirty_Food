import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/widgets/SpeciesStats.dart';
import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';

class Salescard2 extends StatelessWidget {
  final Map speices;
  final double widths;
  final double height;
  const Salescard2(
      {super.key,
      required this.speices,
      required this.widths,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SpeciesStats(name: "${speices['name']}")),
          );
        },
        child: TransparentImageCard(
          width: widths,
          height: height,
          imageProvider:
              NetworkImage('http://localhost:3000/${speices['ImgLink']}'),
          // tags: [ _tag('Product', () {}), ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${speices['name']}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width / 80)),
              const Icon(Icons.arrow_outward, size: 20, color: Colors.green),
            ],
          ),
          description: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('المبيعات: ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 100)),
                Text(numberFormatter(speices['tot_sales']),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width / 80)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
