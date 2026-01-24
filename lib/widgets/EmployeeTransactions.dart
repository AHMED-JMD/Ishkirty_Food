import 'dart:convert';

import 'package:ashkerty_food/Components/tables/EmployeeTransTable.dart';
import 'package:ashkerty_food/models/EmpTrans.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API/Employee.dart' as api;
import '../models/Employee.dart';
import '../providers/Auth_provider.dart';

class EmployeeTransactionsPage extends StatefulWidget {
  final Employee emp;
  const EmployeeTransactionsPage({Key? key, required this.emp})
      : super(key: key);

  @override
  State<EmployeeTransactionsPage> createState() =>
      _EmployeeTransactionsPageState();
}

class _EmployeeTransactionsPageState extends State<EmployeeTransactionsPage> {
  List<Employee> employees = [];
  bool loading = false;
  DateTime todayDate = DateTime.now();
  String period =
      '${DateTime.now().day}/${DateTime.now().month}'; //current day/month

  Employee? selectedEmp;
  DateTime? startDate;
  DateTime? endDate;

  List<EmpTransaction> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions(todayDate, todayDate);
  }

  Future fetchTransactions(
    DateTime startDate,
    DateTime endDate,
  ) async {
    setState(() => loading = true);
    //call server
    final dto = {
      'emp_id': widget.emp.id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };

    final res = await api.APIEmployee.getTrans(dto);
    transactions = [];
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      List data = List.from(body);
      transactions = data.map((t) => EmpTransaction.fromJson(t)).toList();
    } else {
      showMessage('Failed to load transactions');
    }
    setState(() {
      loading = false;
      period =
          'من : ${startDate.year}/${startDate.month}/${startDate.day} الى : ${endDate.year}/${endDate.month}/${endDate.day}';
    });
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.greenAccent, content: Text(msg)));
  }

  void showAddTrans() async {
    final amountCtrl = TextEditingController();
    final empCtrl = TextEditingController(text: widget.emp.name);

    String type = 'خصم';
    DateTime date = DateTime.now();

    await showDialog(
        context: context,
        builder: (ctx) {
          String paymentMethod = 'كاش';
          return AlertDialog(
            title: Center(child: Text('يومية العامل ${widget.emp.name}')),
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: empCtrl,
                      decoration:
                          const InputDecoration(labelText: 'اسم الموظف'),
                      readOnly: true,
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      items: const [
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
                        const Text('التاريخ: '),
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
                      'emp_id': widget.emp.id,
                      'type': type,
                      'amount': double.tryParse(amountCtrl.text) ?? 0,
                      'date': date.toIso8601String(),
                      'paymentMethod': paymentMethod,
                    };
                    final res = await api.APIEmployee.addTrans(dto);
                    if (res.statusCode == 200) {
                      await fetchTransactions(todayDate, todayDate);
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

  void confirmDelete(EmpTransaction t) async {
    final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
              title: const Center(child: Text('حذف المعاملة')),
              content: Text(
                'هل انت متأكد من حذف المعاملة بتاريخ ${t.date.year}/${t.date.month}/${t.date.day} ؟',
                style: const TextStyle(fontSize: 16),
                textDirection: TextDirection.rtl,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'الغاء',
                      style: TextStyle(color: Colors.black),
                    )),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text(
                      'حذف',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ));
    if (ok == true) {
      final res = await api.APIEmployee.deleteTrans({'id': t.id});
      if (res.statusCode == 200) {
        await fetchTransactions(todayDate, todayDate);
      } else {
        showMessage(res.body);
      }
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
                Icons.arrow_back,
                size: 37,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/employees');
              },
            ),
            title: Center(
                child: Text('خصومات [${widget.emp.name}]',
                    style: const TextStyle(fontSize: 30, color: Colors.white))),
            actions: const [LeadingDrawerBtn()],
            toolbarHeight: 45,
          ),
          endDrawer: const MyDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: value.user == null || value.user!['role'] != 'admin'
                ? const Center(
                    child: Text('انت غير مخول للوصول الى هذه الصفحة',
                        style: TextStyle(fontSize: 30, color: Colors.red)))
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  final d = await showDatePicker(
                                      context: context,
                                      initialDate: startDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  if (d != null) setState(() => startDate = d);
                                },
                                icon: const Icon(
                                  Icons.date_range,
                                  color: Colors.teal,
                                ),
                                label: Text(
                                  startDate == null
                                      ? 'اختر : تاريخ البداية'
                                      : '${startDate!.year}/${startDate!.month}/${startDate!.day}',
                                  style: const TextStyle(color: Colors.black),
                                )),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 200,
                            height: 40,
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  final d = await showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                  if (d != null) setState(() => endDate = d);
                                },
                                icon: const Icon(
                                  Icons.date_range,
                                  color: Colors.teal,
                                ),
                                label: Text(
                                  endDate == null
                                      ? 'اختر : تاريخ النهاية'
                                      : '${endDate!.year}/${endDate!.month}/${endDate!.day}',
                                  style: const TextStyle(color: Colors.black),
                                )),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                if (startDate == null || endDate == null) {
                                  showMessage('الرجاء اختيار كلا التاريخين');
                                  return;
                                }
                                fetchTransactions(startDate!, endDate!);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                              child: const Text(
                                'عرض',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                              onPressed: showAddTrans,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                              label: const Text(
                                'اضافة معاملة',
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(width: 12),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Expanded(
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Text(
                                        ' ($period)',
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    EmployeeTranTable(
                                        transactions: transactions,
                                        confirmDelete: confirmDelete)
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
