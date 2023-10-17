import 'package:ashkerty_food/widgets/Monthly_Sales.dart';
import 'package:ashkerty_food/widgets/Weekly_Sales.dart';
import 'package:ashkerty_food/widgets/Yearly_Sales.dart';
import 'package:flutter/material.dart';
import '';
class EndDrawer extends StatelessWidget {
  const EndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 510,
        height: 50,
        color: const Color(0xffffffff),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new WeeklySales(),
                  ),
                );
              },
              child: const Text(
                'إيرادات الإسبوع',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 50,),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new MonthlySales(),
                  ),
                );
              },
              child: const Text(
                'إيرادات الشهر',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 50,),
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new YearlySales(),
                  ),
                );
              },
              child: const Text(
                'إيرادات السنة',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),


    );
  }
}
