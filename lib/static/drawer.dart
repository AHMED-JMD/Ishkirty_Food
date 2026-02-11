import 'package:ashkerty_food/providers/Auth_provider.dart';
// import 'package:ashkerty_food/static/CheckTime.dart';
import 'package:ashkerty_food/widgets/Profile.dart';
import 'package:ashkerty_food/widgets/businessLocation.dart';
import 'package:ashkerty_food/API/Daily.dart';
import 'package:ashkerty_food/utils/businessLocation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      return Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: Colors.teal[400],
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                            final auth_provider = context.read<AuthProvider>();
                            auth_provider.Logout();
                          },
                          icon: const Icon(
                            Icons.power_settings_new,
                            size: 30,
                            color: Color(0xffdc0a19),
                          ),
                        ),
                        Container(
                          color: Colors.grey,
                          child: const Icon(
                            Icons.person_pin,
                            color: Colors.yellowAccent,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${value.user['username']}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 28),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UserProfile()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'الملف الشخصي',
                                style: TextStyle(
                                    color: Colors.grey[300], fontSize: 17),
                              ),
                              const Icon(Icons.edit_note),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // CheckTime(),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              content: SizedBox(
                                width: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.shade700,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.sync,
                                        size: 36,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'جاري مزامنة بيانات اليوم',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'الرجاء الانتظار حتى اكتمال العملية',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 20),
                                    const SizedBox(
                                      height: 36,
                                      width: 36,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          final adminId = value.user['id']?.toString();
                          final location = AuthContext.businessLocation;
                          final res = await APIDaily.syncDaily({
                            'admin_id': adminId,
                            'date': DateTime.now().toIso8601String(),
                            'business_location': location,
                          });
                          Navigator.of(context, rootNavigator: true).pop();
                          if (res.statusCode == 200) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                content: SizedBox(
                                  width: 300,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.teal.shade700,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_circle,
                                          size: 36,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'تمت المزامنة بنجاح اليوم',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                content: SizedBox(
                                  width: 300,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 219, 227, 226),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.cancel,
                                          size: 36,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'خطأ ${res.body}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.sync, color: Colors.white),
                        label: const Text(
                          'مزامنة البيانات اليومية',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Super-admin: manage business locations
                    value.user != null &&
                            value.user['role'] != null &&
                            value.user['role']
                                .toString()
                                .toLowerCase()
                                .contains('super')
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const BusinessLocationPage()));
                            },
                            child: const ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.teal,
                              ),
                              title: Text(
                                'المواقع',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    value.user != null &&
                            value.user['role']
                                .toString()
                                .toLowerCase()
                                .contains('admin')
                        ? Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/safe');
                                },
                                child: const ListTile(
                                  leading: Icon(
                                    Icons.safety_check,
                                    color: Colors.teal,
                                  ),
                                  title: Text(
                                    'الخزنة',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),

                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/daily');
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.badge,
                          color: Colors.teal,
                        ),
                        title: Text(
                          'اليوميات',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/newDaily');
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.badge,
                          color: Colors.teal,
                        ),
                        title: Text(
                          'يومية جديدة',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/store_sell');
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.store,
                          color: Colors.teal,
                        ),
                        title: Text(
                          'مخزن البيع',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/sales');
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.local_mall,
                          color: Colors.teal,
                        ),
                        title: Text(
                          'المبيعات',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/bills');
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.view_list_rounded,
                          color: Colors.teal,
                        ),
                        title: Text(
                          'الفواتير',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/employees');
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.badge,
                          color: Colors.teal,
                        ),
                        title: Text(
                          'الموظفين',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/speices');
                      },
                      child: const ListTile(
                        leading: Icon(
                          Icons.fastfood_sharp,
                          color: Colors.teal,
                        ),
                        title: Text(
                          'الاصناف',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pushReplacementNamed(context, '/clients');
                    //   },
                    //   child: const ListTile(
                    //     leading: Icon(
                    //       Icons.person,
                    //       color: Colors.teal,
                    //     ),
                    //     title: Text(
                    //       'العملاء',
                    //       style: TextStyle(fontSize: 18),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
