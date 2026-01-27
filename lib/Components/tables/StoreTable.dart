import 'package:ashkerty_food/models/StockItem.dart';
import 'package:flutter/material.dart';
import 'package:ashkerty_food/static/formatter.dart';

class StoreTable extends StatelessWidget {
  final List<StockItem> items;
  final void Function(StockItem) confirmDelete;
  final void Function({StockItem? item}) showForm;

  const StoreTable(
      {required this.items,
      required this.confirmDelete,
      required this.showForm,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    'الكمية',
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
                    'انذار الكمية',
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
                    'سعر البيع',
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
                    'سعر الوحدة',
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
                    'الإجراءات',
                    style: TextStyle(fontSize: 20, color: Colors.teal),
                  ))),
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
                  child: Text(
                    it.name,
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
                    it.isKilo
                        ? "${numberFormatter(it.quantity, fractionDigits: 2)} / كجم"
                        : "${numberFormatter(it.quantity)} / قطع",
                    style: TextStyle(
                        fontSize: 17,
                        color: it.quantity <= it.warnValue ? Colors.red : null),
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
                    it.isKilo
                        ? "${numberFormatter(it.warnValue, fractionDigits: 2)} / كجم"
                        : "${numberFormatter(it.warnValue)} / قطع",
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
                    "${numberFormatter(it.sellPrice)} (جنيه)",
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
                  child: Row(
                    children: [
                      Text(
                        it.isKilo
                            ? "${numberFormatter(it.sellPrice / 1000, fractionDigits: 2)}  جنيه"
                            : "${numberFormatter(it.sellPrice)}  جنيه",
                        style: const TextStyle(fontSize: 17),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        it.isKilo
                            ? Icons.money_off_csred
                            : Icons.monetization_on,
                        size: 18,
                        color: Colors.teal,
                      ),
                    ],
                  ),
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
                          Icons.edit,
                          size: 18,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () => showForm(item: it),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 18,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => confirmDelete(it),
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
