import 'package:flutter/material.dart';
import 'package:ashkerty_food/models/PurchaseRequest.dart';
import 'package:ashkerty_food/static/formatter.dart';

class PurchaseTable extends StatelessWidget {
  final List<PurchaseRequest> items;
  final void Function(PurchaseRequest) onDelete;

  const PurchaseTable({required this.items, required this.onDelete, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(
              label: Container(
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
                  child: const Text('الصنف',
                      style: TextStyle(fontSize: 20, color: Colors.teal)))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text('المورد',
                      style: TextStyle(fontSize: 20, color: Colors.teal)))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text('الكمية',
                      style: TextStyle(fontSize: 20, color: Colors.teal)))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text('سعر الشراء',
                      style: TextStyle(fontSize: 20, color: Colors.teal)))),
          DataColumn(
              label: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: const Text('الإجراءات',
                      style: TextStyle(fontSize: 20, color: Colors.teal)))),
        ],
        rows: items.map((it) {
          return DataRow(
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                return int.parse(it.id).isEven ? Colors.grey.shade200 : null;
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
                    child: Text(it.store.name,
                        style: const TextStyle(fontSize: 17)))),
                DataCell(Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.grey.shade300, width: 1))),
                    child:
                        Text(it.vendor, style: const TextStyle(fontSize: 17)))),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text(
                      it.store.isKilo
                          ? '${it.quantity} / كجم'
                          : '${it.quantity} / قطعة',
                      style: const TextStyle(fontSize: 17)),
                )),
                DataCell(Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Colors.grey.shade300, width: 1))),
                  child: Text("${numberFormatter(it.buyPrice)} (جنيه)",
                      style: const TextStyle(fontSize: 17)),
                )),
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
                        icon: const Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => onDelete(it),
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
