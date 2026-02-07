import 'package:ashkerty_food/models/EmpTrans.dart';
import 'package:flutter/material.dart';
import 'package:ashkerty_food/static/formatter.dart';

class EmployeeTranTable extends StatelessWidget {
  final Map admin;
  final List<EmpTransaction> transactions;
  final void Function(EmpTransaction, String) confirmDelete;

  EmployeeTranTable(
      {required this.admin,
      required this.transactions,
      required this.confirmDelete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAdmin = admin['role'] == 'admin' ? true : false;

    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
              label: Container(
                  child: const Text(
            'الاسم',
            style: TextStyle(fontSize: 20, color: Colors.teal),
          ))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text(
                    'النوع',
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text(
                    'التاريخ',
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text(
                    'المبلغ',
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text(
                    'طريقة الدفع',
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text(
                    'المستخدم',
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ))),
          if (isAdmin)
            DataColumn(
                label: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.grey.shade300, width: 1))),
                    child: const Text(
                      'اجراء',
                      style: TextStyle(fontSize: 20, color: Colors.teal),
                    ))),
        ],
        rows: transactions.map((t) {
          return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                return t.type == 'اضافة'
                    ? Colors.redAccent.shade200
                    : t.id.isEven
                        ? Colors.grey.shade200
                        : null;
              }),
              cells: [
                DataCell(Container(
                  child: Text(
                    t.employeeName,
                    style: const TextStyle(fontSize: 17),
                  ),
                )),
                DataCell(Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.grey.shade300, width: 1))),
                    child: Text(
                      t.type == 'اضافة' ? 'بداية اسبوع' : t.type,
                      style: const TextStyle(fontSize: 17),
                    ))),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text(
                    '${t.date.year}-${t.date.month}-${t.date.day}',
                    style: const TextStyle(fontSize: 17),
                  ),
                )),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text(
                    '${numberFormatter(t.amount)} (جنيه)',
                    style: const TextStyle(fontSize: 17),
                  ),
                )),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text(
                    t.paymentMethod,
                    style: const TextStyle(fontSize: 17),
                  ),
                )),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text(
                    t.admin,
                    style: const TextStyle(fontSize: 17),
                  ),
                )),
                if (isAdmin)
                  DataCell(Row(children: [
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color:
                              t.type == 'اضافة' ? Colors.redAccent : Colors.red,
                        ),
                        onPressed: () {
                          t.type != 'اضافة'
                              ? confirmDelete(t, admin['id'].toString())
                              : null;
                        })
                  ])),
              ]);
        }).toList(),
      ),
    );
  }
}
