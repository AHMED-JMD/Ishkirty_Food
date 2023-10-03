import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'مرحبا',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'اشكرتي ادمن',
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
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: ListTile(
                  leading: Icon(
                    Icons.home_work_rounded,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'الرئيسية',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/orders');
                },
                child: ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'الطلبات',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/speices');
                },
                child: ListTile(
                  leading: Icon(
                    Icons.menu,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'الاصناف',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/clients');
                },
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'العملاء',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/sales');
                },
                child: ListTile(
                  leading: Icon(
                    Icons.local_mall,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    'المبيعات',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: ListTile(
                  leading: Icon(
                    Icons.power_settings_new_outlined,
                    color: Colors.blue,
                  ),
                  title: const Text(
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
  }
}
