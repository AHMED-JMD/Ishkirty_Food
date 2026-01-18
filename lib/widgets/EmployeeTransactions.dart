import 'dart:convert';

import 'package:ashkerty_food/models/EmpTrans.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../API/Employee.dart' as api;
import '../models/Employee.dart';
import '../providers/Auth_provider.dart';

class EmployeeTransactionsPage extends StatefulWidget {
  final String empId;
  const EmployeeTransactionsPage({Key? key, required this.empId})
      : super(key: key);

  @override
  State<EmployeeTransactionsPage> createState() =>
      _EmployeeTransactionsPageState();
}

class _EmployeeTransactionsPageState extends State<EmployeeTransactionsPage> {
  List<Employee> employees = [];
  bool loading = false;

  Employee? selectedEmp;
  DateTime? startDate;
  DateTime? endDate;

  List<EmpTransaction> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future fetchTransactions() async {
    setState(() => loading = true);

    //call server
    final dto = {
      'emp_id': widget.empId,
      if (startDate != null) 'start': startDate!.toIso8601String(),
      if (endDate != null) 'end': endDate!.toIso8601String(),
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
    setState(() => loading = false);
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.greenAccent, content: Text(msg)));
  }

  Future showAddTrans() async {
    final amountCtrl = TextEditingController();
    String type = 'خصم';
    DateTime date = DateTime.now();

    await showDialog(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('New Transaction for ${widget.empId}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: type,
                      items: const [
                        DropdownMenuItem(value: 'اضافة', child: Text('اضافة')),
                        DropdownMenuItem(value: 'خصم', child: Text('خصم')),
                      ],
                      onChanged: (v) => type = v ?? 'خصم',
                      decoration:
                          const InputDecoration(labelText: 'نوع المعاملة'),
                    ),
                    TextFormField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(labelText: 'المبلغ'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
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
                        'emp_id': widget.empId,
                        'type': type,
                        'amount': double.tryParse(amountCtrl.text) ?? 0,
                        'date': date.toIso8601String()
                      };
                      final res = await api.APIEmployee.addTrans(dto);
                      if (res.statusCode == 200) {
                        await fetchTransactions();
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

  Future confirmDelete(EmpTransaction t) async {
    final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
              title: const Center(child: Text('حذف المعاملة')),
              content: Text(
                'هل انت متأكد من حذف المعاملة بتاريخ ${t.date.year}/${t.date.month}/${t.date.day} ؟',
                textDirection: TextDirection.rtl,
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('الغاء')),
                ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('حذف'))
              ],
            ));
    if (ok == true) {
      final res = await api.APIEmployee.deleteTrans({'id': t.id});
      if (res.statusCode == 200) {
        await fetchTransactions();
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
            title: const Center(
                child:
                    Text('معاملات الموظفين', style: TextStyle(fontSize: 25))),
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
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<Employee>(
                              value: widget.empId.isNotEmpty
                                  ? Employee.fromJson({
                                      'id': int.parse(widget.empId),
                                      'name': ''
                                    })
                                  : selectedEmp,
                              isExpanded: true,
                              hint: const Text('اختر موظف'),
                              items: employees
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e.name)))
                                  .toList(),
                              onChanged: (v) {
                                setState(() {
                                  selectedEmp = v;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                    context: context,
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (d != null) setState(() => startDate = d);
                              },
                              child: Text(startDate == null
                                  ? 'تاريخ البداية'
                                  : '${startDate!.year}/${startDate!.month}/${startDate!.day}')),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                    context: context,
                                    initialDate: endDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (d != null) setState(() => endDate = d);
                              },
                              child: Text(endDate == null
                                  ? 'تاريخ النهاية'
                                  : '${endDate!.year}/${endDate!.month}/${endDate!.day}')),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: fetchTransactions,
                              child: const Text('عرض')),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: showAddTrans,
                              child: const Text('اضافة معاملة')),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : SingleChildScrollView(
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('التاريخ')),
                                    DataColumn(label: Text('النوع')),
                                    DataColumn(label: Text('المبلغ')),
                                    DataColumn(label: Text('اجراء')),
                                  ],
                                  rows: transactions.map((t) {
                                    return DataRow(cells: [
                                      DataCell(Text(
                                          '${t.date.year}/${t.date.month}/${t.date.day}')),
                                      DataCell(Text(t.type)),
                                      DataCell(Text(
                                          '${numberFormatter(t.amount)} (جنيه)')),
                                      DataCell(Row(children: [
                                        IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () => confirmDelete(t))
                                      ])),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                      )
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
