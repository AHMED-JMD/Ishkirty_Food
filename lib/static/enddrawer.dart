import 'package:flutter/material.dart';


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
              },
              child: const Text(
                'إيرادات الإسبوع',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 50,),
            InkWell(
              onTap: (){
              },
              child: const Text(
                'إيرادات الشهر',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 50,),
            InkWell(
              onTap: (){
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
