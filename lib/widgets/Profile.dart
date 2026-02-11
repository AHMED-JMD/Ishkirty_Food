import 'dart:convert';
import 'package:ashkerty_food/API/Auth.dart';
import 'package:ashkerty_food/Components/Forms/AddAdminForm.dart';
import 'package:ashkerty_food/Components/Forms/ChangePassword.dart';
import 'package:ashkerty_food/Components/Forms/TransactForm.dart';
import 'package:ashkerty_food/Components/tables/ManagersTable.dart';
import 'package:ashkerty_food/Components/tables/UserBillsTable.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/API/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List data = [];
  List managers = [];
  List categories = [];
  bool isLoading = false;
  bool categoriesLoading = false;

  @override
  void initState() {
    super.initState();
    getManagers();
    getCategories();
  }

  // get categories
  Future getCategories() async {
    setState(() {
      categoriesLoading = true;
    });

    final response = await APICategory.Get();
    if (response != false) {
      setState(() {
        categories = response;
        categoriesLoading = false;
      });
    } else {
      setState(() {
        categories = [];
        categoriesLoading = false;
      });
    }
  }

  // delete category with confirmation
  Future deleteCategory(id) async {
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Center(child: Text('تأكيد الحذف')),
              content: const Text('هل تريد حذف هذه الفئة؟'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('الغاء')),
                TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child:
                        const Text('حذف', style: TextStyle(color: Colors.red)))
              ],
            ));

    if (confirmed == true) {
      setState(() {
        categoriesLoading = true;
      });
      final res = await APICategory.Delete({'id': id});
      setState(() {
        categoriesLoading = false;
      });
      if (res == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('تم الحذف'),
          backgroundColor: Colors.green,
        ));
        getCategories();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // add category dialog
  Future addCategoryDialog() async {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Text('اضافة قائمة جديدة'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'الاسم'),
                  ),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: 'الوصف'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('الغاء')),
                TextButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      final desc = descCtrl.text.trim();
                      if (name.isEmpty) return;
                      Navigator.pop(ctx, true);
                      setState(() {
                        categoriesLoading = true;
                      });
                      final res = await APICategory.Add({
                        'name': name,
                        'description': desc,
                      });
                      setState(() {
                        categoriesLoading = false;
                      });
                      if (res == true) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('تمت الاضافة'),
                          backgroundColor: Colors.green,
                        ));
                        getCategories();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(res.toString()),
                          backgroundColor: Colors.red,
                        ));
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text(
                      'اضافة',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          );
        });
    return confirmed;
  }

  //function to get managers
  Future getManagers() async {
    setState(() {
      isLoading = true;
    });
    //call server
    final response = await APIAuth.GetManagers();

    final datas = jsonDecode(response.body);

    setState(() {
      isLoading = false;
      managers = datas;
    });
  }

  //function to add new admin
  Future addAdmin(data) async {
    setState(() {
      isLoading = true;
    });
    //call server
    final response = await APIAuth.Register(data);
    setState(() {
      isLoading = false;
    });

    // call get managers again to get new data
    getManagers();

    if (response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text(
            'تمت اضافة مستخدم جديد بنجاح',
            style: TextStyle(fontSize: 22),
          ),
        ),
        backgroundColor: Colors.green,
      ));
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
          child: Text(
            '${response.body}',
            style: const TextStyle(fontSize: 22),
          ),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            leading: IconButton(
              icon: const Icon(
                Icons.home_work,
                size: 37,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            title: const Center(
              child: Text("الملف الشخصي",
                  style: TextStyle(
                    fontSize: 25,
                  )),
            ),
            actions: const [
              LeadingDrawerBtn(),
            ],
            toolbarHeight: 45,
          ),
          endDrawer: const MyDrawer(),
          body: ListView(
            children: [
              Container(
                color: Colors.tealAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'مرحبا,',
                          style: TextStyle(fontSize: 23, color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${value.user['username']}',
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    value.user['role'] != null &&
                            value.user['role']
                                .toString()
                                .toLowerCase()
                                .contains('admin')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChangePassword(admin_id: value.user['id']),
                              const SizedBox(
                                width: 20,
                              ),
                              Add_Admin(addAdmin: addAdmin)
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChangePassword(admin_id: value.user!['id'] ?? ""),
                              const SizedBox(
                                width: 20,
                              ),
                              TransferFormModal(
                                  admin_id: value.user['id'] ?? ""),
                            ],
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),

              // Categories horizontal clickable cards (similar to menu_nav)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'قائمة الطعام',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    if (value.user['role'] != null &&
                        value.user['role']
                            .toString()
                            .toLowerCase()
                            .contains('admin'))
                      ElevatedButton.icon(
                        onPressed: addCategoryDialog,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'اضافة',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                      )
                  ],
                ),
              ),

              Container(
                height: 120,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: categoriesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            return GestureDetector(
                              onTap: () {
                                // You can add navigation or edit action here
                              },
                              child: Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 185),
                                    width: 140,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.teal.shade400,
                                          size: 28,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${cat['name'] ?? ''}',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (value.user['role'] != null &&
                                      value.user['role']
                                          .toString()
                                          .toLowerCase()
                                          .contains('admin'))
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: InkWell(
                                        onTap: () => deleteCategory(cat['id'] ??
                                            cat['ID'] ??
                                            cat['_id']),
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.delete,
                                              size: 14, color: Colors.white),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ),

              const SizedBox(
                height: 80,
              ),
              data.isNotEmpty || isLoading == false
                  ? Container(
                      color: Colors.grey[100],
                      child: value.user['role'] != null &&
                              value.user['role']
                                  .toString()
                                  .toLowerCase()
                                  .contains('admin')
                          ? Column(
                              children: [
                                const Center(
                                  child: Text(
                                    'الكاشيرز',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ManagerTable(data: managers),
                              ],
                            )
                          : Column(
                              children: [
                                const Center(
                                  child: Text(
                                    'الفواتير المحررة اليوم',
                                    style: TextStyle(
                                        fontSize: 26, color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                UserBillsTable(admin_id: value.user['id']),
                              ],
                            ))
                  : const Padding(
                      padding: EdgeInsets.only(top: 190.0),
                      child: SpinKitPouringHourGlassRefined(
                        color: Colors.teal,
                        size: 70.0,
                      ),
                    ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      );
    });
  }
}
