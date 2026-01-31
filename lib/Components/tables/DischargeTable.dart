import 'package:flutter/material.dart';
import 'package:ashkerty_food/models/Discharge.dart';
import 'package:ashkerty_food/static/formatter.dart';

class DischargeTable extends StatelessWidget {
  final Map admin;
  final List<Discharge> items;
  final void Function(Discharge, String) onDelete;

  const DischargeTable(
      {required this.admin,
      required this.items,
      required this.onDelete,
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
            child: const Text('التاريخ',
                style: TextStyle(fontSize: 20, color: Colors.teal)),
          )),
          DataColumn(
              label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.grey.shade300, width: 1))),
            child: const Text('الإسم',
                style: TextStyle(fontSize: 20, color: Colors.teal)),
          )),
          DataColumn(
              label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.grey.shade300, width: 1))),
            child: const Text('المبلغ',
                style: TextStyle(fontSize: 20, color: Colors.teal)),
          )),
          DataColumn(
              label: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.grey.shade300, width: 1))),
            child: const Text('شهري؟',
                style: TextStyle(fontSize: 20, color: Colors.teal)),
          )),
          if (isAdmin)
            DataColumn(
                label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  border: Border(
                      right:
                          BorderSide(color: Colors.grey.shade300, width: 1))),
              child: const Text('الإجراءات',
                  style: TextStyle(fontSize: 20, color: Colors.teal)),
            )),
        ],
        rows: items.map((it) {
          return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                return int.parse(it.id.toString()).isEven
                    ? Colors.grey.shade200
                    : null;
              }),
              cells: [
                DataCell(Container(
                  child: Text(it.date.toIso8601String().split('T').first,
                      style: const TextStyle(fontSize: 17)),
                )),
                DataCell(Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.grey.shade300, width: 1))),
                    child:
                        Text(it.name, style: const TextStyle(fontSize: 17)))),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text('${numberFormatter(it.price)} (جنيه)',
                      style: const TextStyle(fontSize: 17)),
                )),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text(it.isMonthly ? 'نعم' : 'لا',
                      style: const TextStyle(fontSize: 17)),
                )),
                if (isAdmin)
                  DataCell(Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.grey.shade300, width: 1))),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete,
                              size: 18, color: Colors.redAccent),
                          onPressed: () => onDelete(it, admin['id'].toString()),
                        ),
                      ],
                    ),
                  )),
              ]);
        }).toList(),
      ),
    );
  }
}
