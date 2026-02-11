import 'dart:convert';

import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/static/Printing.dart';
import 'package:ashkerty_food/widgets/EmployeeTransactions.dart';
import 'package:ashkerty_food/Components/tables/EmployeeTable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API/Employee.dart' as api;
import '../models/Employee.dart';
import '../providers/Auth_provider.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

// Employee table logic moved to Components/tables/EmployeeTable.dart

class _EmployeePageState extends State<EmployeePage> {
  List<Employee> employees = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future fetchEmployees() async {
    setState(() => loading = true);

    final res = await api.APIEmployee.getAll();
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      employees = data.map((e) => Employee.fromJson(e)).toList();
    } else {
      showMessage('Failed to load employees');
    }

    setState(() => loading = false);
  }

  Future _runNewMonth(String adminId) async {
    setState(() => loading = true);

    final res = await api.APIEmployee.runNewMonth({'admin_id': adminId});
    if (res.statusCode == 200) {
      fetchEmployees();
    } else {
      showMessage('Failed to load new month data');
    }

    setState(() => loading = false);
  }

  double get totalSalaries => employees.fold(0.0, (p, e) => p + e.salary);

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.greenAccent, content: Text(msg)));
  }

  void showEmployeeForm([Employee? emp, String? adminId]) async {
    final nameCtrl = TextEditingController(text: emp != null ? emp.name : '');
    final jobCtrl =
        TextEditingController(text: emp != null ? emp.jobTitle : '');
    final shiftCtrl = TextEditingController(text: emp != null ? emp.shift : '');
    final fixSalaryCtrl = TextEditingController(
        text: emp != null ? emp.fixedSalary.toString() : '');
    //-----------------for viewing only
    // final curSalaryCtrl = TextEditingController(
    //     text: emp != null ? emp.fixedSalary.toString() : '0');

    final formKey = GlobalKey<FormState>();

    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Center(
                child: Text(emp == null ? 'اضف موظف' : 'تعديل بيانات الموظف')),
            content: Form(
              key: formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'الاسم'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                      DropdownButtonFormField<String>(
                        initialValue:
                            shiftCtrl.text.isNotEmpty ? shiftCtrl.text : null,
                        decoration:
                            const InputDecoration(labelText: 'اختر الوردية'),
                        items: [
                          'صباحي',
                          'مسائي',
                          'كامل اليوم',
                        ]
                            .map((shift) => DropdownMenuItem(
                                  value: shift,
                                  child: Text(shift),
                                ))
                            .toList(),
                        onChanged: (val) {
                          shiftCtrl.text = val ?? '';
                        },
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: jobCtrl,
                        decoration: const InputDecoration(labelText: 'الوظيفة'),
                      ),
                      // TextFormField(
                      //   controller: curSalaryCtrl,
                      //   readOnly: true,
                      //   keyboardType: TextInputType.number,
                      //   validator: (v) =>
                      //       double.tryParse(v ?? '') == null ? 'Invalid' : null,
                      //   decoration: const InputDecoration(labelText: 'الراتب'),
                      // ),
                      TextFormField(
                        controller: fixSalaryCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) =>
                            double.tryParse(v ?? '') == null ? 'Invalid' : null,
                        decoration: const InputDecoration(
                            labelText: 'الراتب الاسبوعي الثابت'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'الغاء',
                    style: TextStyle(color: Colors.red),
                  )),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final dto = {
                    if (emp?.id != null) 'id': emp!.id,
                    'name': nameCtrl.text,
                    'jobTitle': jobCtrl.text,
                    'shift': shiftCtrl.text,
                    'salary': double.tryParse(fixSalaryCtrl.text) ?? 0,
                    if (adminId != null) 'admin_id': adminId,
                  };
                  Navigator.pop(ctx);
                  // call API
                  if (emp == null) {
                    final res = await api.APIEmployee.add(dto);
                    if (res.statusCode == 200) {
                      await fetchEmployees();
                    } else {
                      showMessage(res.body);
                    }
                  } else {
                    final res = await api.APIEmployee.update(dto);
                    if (res.statusCode == 200) {
                      await fetchEmployees();
                    } else {
                      showMessage(res.body);
                    }
                  }
                },
                child: const Text('حفظ', style: TextStyle(color: Colors.teal)),
              )
            ],
          );
        });
  }

  void showAddTrans(List<Employee> emps, String adminId) async {
    final amountCtrl = TextEditingController();
    String type = 'خصم';
    DateTime date = DateTime.now();
    Employee emp = emps[0];

    await showDialog(
        context: context,
        builder: (ctx) {
          String paymentMethod = 'كاش';

          return AlertDialog(
            title: Center(child: Text('يومية العامل ${emp.name}')),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    DropdownButtonFormField<Employee>(
                      initialValue: emp,
                      items: emps
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (v) => emp = v ?? emps[0],
                      decoration:
                          const InputDecoration(labelText: 'اختر الموظف'),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      items: const [
                        // DropdownMenuItem(value: 'اضافة', child: Text('اضافة')),
                        DropdownMenuItem(value: 'خصم', child: Text('خصم')),
                      ],
                      onChanged: (v) => type = v ?? 'خصم',
                      decoration:
                          const InputDecoration(labelText: 'نوع المعاملة'),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: paymentMethod,
                      items: const [
                        DropdownMenuItem(value: 'كاش', child: Text('كاش')),
                        DropdownMenuItem(value: 'بنكك', child: Text('بنكك')),
                        DropdownMenuItem(value: 'فوري', child: Text('فوري')),
                      ],
                      onChanged: (v) => paymentMethod = v ?? 'كاش',
                      decoration:
                          const InputDecoration(labelText: 'طريقة الدفع'),
                    ),
                    TextFormField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(labelText: 'المبلغ'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Text(
                          'التاريخ: ',
                          style: TextStyle(fontSize: 17),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              final d = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (d != null) date = d;
                            },
                            child: Text(
                              '${date.year}/${date.month}/${date.day}',
                              style: const TextStyle(fontSize: 17),
                            ))
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'الغاء',
                    style: TextStyle(color: Colors.red),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final dto = {
                      'emp_id': emp.id,
                      'admin_id': adminId,
                      'type': type,
                      'amount': double.tryParse(amountCtrl.text) ?? 0,
                      'date': date.toIso8601String(),
                      'payment_method': paymentMethod,
                    };
                    //call server
                    final res = await api.APIEmployee.addTrans(dto);
                    if (res.statusCode == 200) {
                      await fetchEmployees();
                    } else {
                      showMessage(res.body);
                    }
                  },
                  child: const Text(
                    'حفظ',
                    style: TextStyle(color: Colors.teal),
                  ))
            ],
          );
        });
  }

  void _confirmDelete(Employee emp, String adminId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(child: Text('حذف الموظف')),
        content: Text(
          "هل انت متأكد من حذف الموظف ${emp.name} ؟",
          style: const TextStyle(fontSize: 18),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('الغاء', style: TextStyle(color: Colors.black))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final res = await api.APIEmployee.delete(
                  {'id': emp.id, 'admin_id': adminId});
              if (res.statusCode == 200) {
                await fetchEmployees();
              } else {
                showMessage(res.body);
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child) {
      bool isAdmin = value.user['role'] != null &&
          value.user['role'].toString().toLowerCase().contains('admin');

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
                child: Text(
              "الموظفين",
              style: TextStyle(fontSize: 25),
            )),
            actions: const [
              LeadingDrawerBtn(),
            ],
            toolbarHeight: 45,
          ),
          endDrawer: const MyDrawer(),
          body: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (isAdmin)
                    ElevatedButton.icon(
                        onPressed: () {
                          _runNewMonth(value.user!['id']);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        icon: const Icon(Icons.calendar_month,
                            color: Colors.white, size: 25),
                        label: const Text(
                          ' تجديد المرتبات ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 160,
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, color: Colors.teal),
                                const SizedBox(height: 8),
                                const Text('عدد الموظفين',
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 6),
                                Text(
                                  '${employees.length}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 180,
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.monetization_on,
                                    color: Colors.orange),
                                const SizedBox(height: 8),
                                const Text('اجمالي المرتبات',
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(height: 6),
                                Text(
                                  "${numberFormatter(totalSalaries)} (جنيه)",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          if (isAdmin)
                            ElevatedButton.icon(
                              onPressed: () {
                                showEmployeeForm(null, value.user!['id']);
                              },
                              icon: const Icon(
                                Icons.add_circle,
                                size: 20,
                                color: Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                backgroundColor: Colors.teal,
                              ),
                              label: const Text(
                                'موظف جديد',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          const SizedBox(width: 20),
                          if (isAdmin)
                            ElevatedButton.icon(
                                onPressed: () {
                                  showAddTrans(employees, value.user!['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20.0),
                                  backgroundColor: Colors.teal,
                                ),
                                label: const Text(
                                  'خصم المرتب',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                icon: const Icon(
                                  Icons.monetization_on,
                                  size: 20,
                                  color: Colors.black,
                                )),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                              onPressed: () async {
                                await printEmployeeSalaries(
                                    admin: value.user!['username'],
                                    employees: employees,
                                    totalSalaries: totalSalaries);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 20.0),
                                backgroundColor: Colors.grey.shade300,
                              ),
                              label: const Text(
                                'طباعة المرتبات',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              icon: const Icon(
                                Icons.print,
                                size: 20,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ],
                  ),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : EmployeeTable(
                          isAdmin: isAdmin,
                          employees: employees,
                          onEdit: (emp) =>
                              showEmployeeForm(emp, value.user!['id']),
                          onDelete: (emp) =>
                              _confirmDelete(emp, value.user!['id']),
                          onView: (emp) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeTransactionsPage(emp: emp))),
                        ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
