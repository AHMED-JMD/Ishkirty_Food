import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child){
      return Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.teal,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحبا',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${value.user['username']}',
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 20),

                InkWell(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/orders');
                  },
                  child: const ListTile(
                    leading:  Icon(
                      Icons.local_mall,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'المبيعات',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/bills');
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.view_list_rounded,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'الفواتير',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/speices');
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.fastfood_sharp,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'الاصناف',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, '/clients');
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    title: Text(
                      'العملاء',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                InkWell(
                  onTap: ()async {
                    final auth_provider = context.read<AuthProvider>();
                    auth_provider.Logout();
                   await Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const ListTile(
                    leading: Icon(
                      Icons.power_settings_new_outlined,
                      color: Color(0xffdc0a19),
                    ),
                    title: Text(
                      'تسجيل الخروج',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
