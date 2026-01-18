import 'dart:convert';

import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:ashkerty_food/widgets/EmployeeTransactions.dart';
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

class _EmployeePageState extends State<EmployeePage> {
  List<Employee> employees = [];
  List<Employee> filtered = [];
  bool loading = false;
  String searchCtrl = '';

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
    _onSearch();
    setState(() => loading = false);
  }

  void _onSearch() {
    if (searchCtrl.trim().isEmpty) {
      filtered = List.from(employees);
    } else {
      final q = searchCtrl.toLowerCase();
      filtered =
          employees.where((emp) => emp.name.toLowerCase().contains(q)).toList();
    }
  }

  double get totalSalaries => employees.fold(0.0, (p, e) => p + e.salary);

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.greenAccent, content: Text(msg)));
  }

  void showEmployeeForm([Employee? emp]) async {
    final nameCtrl = TextEditingController(text: emp != null ? emp.name : '');
    final jobCtrl =
        TextEditingController(text: emp != null ? emp.jobTitle : '');
    final shiftCtrl = TextEditingController(text: emp != null ? emp.shift : '');
    final fixSalaryCtrl =
        TextEditingController(text: emp != null ? emp.salary.toString() : '');
    final curSalaryCtrl = TextEditingController(
        text: emp != null ? emp.fixedSalary.toString() : '0');

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
                        items: ['صباحي', 'مسائي']
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
                      TextFormField(
                        controller: curSalaryCtrl,
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            double.tryParse(v ?? '') == null ? 'Invalid' : null,
                        decoration: const InputDecoration(labelText: 'الراتب'),
                      ),
                      TextFormField(
                        controller: fixSalaryCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (v) =>
                            double.tryParse(v ?? '') == null ? 'Invalid' : null,
                        decoration:
                            const InputDecoration(labelText: 'الراتب الثابت'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('الغاء')),
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  final dto = {
                    if (emp?.id != null) 'id': emp!.id,
                    'name': nameCtrl.text,
                    'jobTitle': jobCtrl.text,
                    'shift': shiftCtrl.text,
                    'salary': double.tryParse(fixSalaryCtrl.text) ?? 0
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

  void showTransForm(Employee emp) async {
    final amountCtrl = TextEditingController();
    String type = 'add';
    DateTime date = DateTime.now();

    await showDialog(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('New Transaction for ${emp.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: type,
                      items: const [
                        DropdownMenuItem(value: 'add', child: Text('Add')),
                        DropdownMenuItem(
                            value: 'deduct', child: Text('Deduct')),
                      ],
                      onChanged: (v) => type = v ?? 'add',
                      decoration: const InputDecoration(labelText: 'Type'),
                    ),
                    TextFormField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Date: '),
                        TextButton(
                            onPressed: () async {
                              final d = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (d != null) date = d;
                            },
                            child:
                                Text('${date.year}/${date.month}/${date.day}'))
                      ],
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      final dto = {
                        'emp_id': emp.id,
                        'type': type,
                        'amount': double.tryParse(amountCtrl.text) ?? 0,
                        'date': date.toIso8601String()
                      };

                      final res = await api.APIEmployee.addTrans(dto);
                      if (res.statusCode == 200) {
                        fetchEmployees();
                      } else {
                        showMessage(res.body);
                      }
                    },
                    child: const Text('Save'))
              ],
            ),
          );
        });
  }

  void _confirmDelete(Employee emp) {
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
              final res = await api.APIEmployee.delete({'id': emp.id});
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
            padding: const EdgeInsets.all(50.0),
            child: value.user == null || value.user!['role'] != 'admin'
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'انت غير مخول للوصول الى هذه الصفحة',
                          style: TextStyle(fontSize: 30, color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Icon(
                          Icons.lock,
                          size: 100,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: TextField(
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'ايجاد موظف بالاسم .....'),
                                  onChanged: (v) {
                                    setState(() {
                                      searchCtrl = v;
                                      _onSearch();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton.icon(
                                onPressed: showEmployeeForm,
                                icon: const Icon(
                                  Icons.add_circle,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20.0),
                                  backgroundColor: Colors.teal,
                                ),
                                label: const Text(
                                  'اضافة موظف',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Row(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.person,
                                            color: Colors.teal),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                          )
                        ],
                      ),
                      const SizedBox(height: 60),
                      Expanded(
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(
                                                label: Text(
                                              'الاسم',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              ' الوظيفة',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'الوردية',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'الراتب (جنيه)',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                            DataColumn(
                                                label: Text(
                                              'الإجراءات',
                                              style: TextStyle(fontSize: 20),
                                            )),
                                          ],
                                          rows: filtered.map((emp) {
                                            return DataRow(cells: [
                                              DataCell(Text(
                                                emp.name,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Text(
                                                emp.jobTitle,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Text(
                                                emp.shift,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Text(
                                                "${numberFormatter(emp.salary)} (جنيه)",
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              )),
                                              DataCell(Row(
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Icons.remove_red_eye,
                                                        size: 18),
                                                    tooltip: 'معاملات الموظف',
                                                    onPressed: () =>
                                                        Navigator.push(context,
                                                            () {
                                                      return MaterialPageRoute(
                                                          builder: (context) =>
                                                              EmployeeTransactionsPage(
                                                                  empId: emp.id
                                                                      .toString()));
                                                    }()),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.edit,
                                                        size: 18),
                                                    tooltip:
                                                        'تعديل بيانات الموظف',
                                                    onPressed: () =>
                                                        showEmployeeForm(emp),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                    ),
                                                    onPressed: () =>
                                                        _confirmDelete(emp),
                                                  ),
                                                ],
                                              )),
                                            ]);
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
