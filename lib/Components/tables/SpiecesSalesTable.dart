import 'package:flutter/material.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:ashkerty_food/models/SpiecesTableModel.dart';

class SpiecesSalesTable extends StatefulWidget {
  final List<SpiecesTableModel> data;
  const SpiecesSalesTable({super.key, required this.data});

  @override
  State<SpiecesSalesTable> createState() => _SpiecesSalesTableState();
}

class _SpiecesSalesTableState extends State<SpiecesSalesTable> {
  String _search = '';
  bool _showPrice = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String q = _search.trim().toLowerCase();
    final List<SpiecesTableModel> filtered = q.isEmpty
        ? widget.data
        : widget.data
            .where((it) =>
                it.name.toLowerCase().contains(q) ||
                it.category.toLowerCase().contains(q))
            .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'ايجاد منتج  .....'),
                onChanged: (v) {
                  setState(() {
                    _search = v;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'عدد الاصناف: ${filtered.length}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700),
            ),
            const SizedBox(width: 24),
            Row(
              children: [
                Checkbox(
                  value: _showPrice,
                  onChanged: (value) {
                    setState(() {
                      _showPrice = value ?? true;
                    });
                  },
                ),
                const Text(
                  'عرض الاسعار',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                  label: Container(
                      child: Text('الاسم',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.teal)))),
              DataColumn(
                  label: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 1))),
                      child: const Text('التصنيف',
                          style: TextStyle(fontSize: 20, color: Colors.teal)))),
              if (_showPrice)
                DataColumn(
                    label: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: Colors.grey.shade300, width: 1))),
                        child: const Text('السعر',
                            style:
                                TextStyle(fontSize: 20, color: Colors.teal)))),
              DataColumn(
                  label: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 1))),
                      child: const Text('البيع',
                          style: TextStyle(fontSize: 20, color: Colors.teal)))),
              DataColumn(
                  label: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 1))),
                      child: const Text('إجمالي المبيعات',
                          style: TextStyle(fontSize: 20, color: Colors.teal)))),
              DataColumn(
                  label: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 1))),
                      child: const Text('التكلفة',
                          style: TextStyle(fontSize: 20, color: Colors.teal)))),
              DataColumn(
                  label: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 1))),
                      child: const Text('إجمالي التكاليف',
                          style: TextStyle(fontSize: 20, color: Colors.teal)))),
              DataColumn(
                  label: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: Colors.grey.shade300, width: 1))),
                      child: const Text(' الربح',
                          style: TextStyle(fontSize: 20, color: Colors.teal)))),
            ],
            rows: filtered
                .map((r) => DataRow(
                        color:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                          return int.parse(r.id).isEven
                              ? Colors.grey.shade200
                              : null;
                        }),
                        cells: [
                          DataCell(Container(
                              child: Text(
                            r.name,
                            style: const TextStyle(fontSize: 17),
                          ))),
                          DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1))),
                              child: Text(r.category,
                                  style: const TextStyle(fontSize: 17)))),
                          if (_showPrice)
                            DataCell(Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1))),
                                child: Text(numberFormatter(r.price),
                                    style: const TextStyle(fontSize: 17)))),
                          DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1))),
                              child: Text(numberFormatter(r.saleSum),
                                  style: const TextStyle(fontSize: 17)))),
                          DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1))),
                              child: Text(numberFormatter(r.totSales),
                                  style: const TextStyle(fontSize: 17)))),
                          DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1))),
                              child: Text(numberFormatter(r.spiceCost),
                                  style: const TextStyle(fontSize: 17)))),
                          DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1))),
                              child: Text(numberFormatter(r.totCosts),
                                  style: const TextStyle(fontSize: 17)))),
                          DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1))),
                              child: Text(
                                  numberFormatter(
                                      (r.totSales - r.totCosts).toInt()),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: (r.totSales - r.totCosts) >= 0
                                          ? Colors.green
                                          : Colors.red)))),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
  }
}
