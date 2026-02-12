import 'package:ashkerty_food/models/Daily.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/material.dart';

class LocationsDailyTable extends StatefulWidget {
  final List<Daily> dailies;

  const LocationsDailyTable({
    super.key,
    required this.dailies,
  });

  @override
  State<LocationsDailyTable> createState() => _LocationsDailyTableState();
}

class _LocationsDailyTableState extends State<LocationsDailyTable> {
  String _locationFilter = 'الكل';

  List<String> _locationOptions() {
    final items = widget.dailies
        .map((d) => d.businessLocation.trim())
        .where((v) => v.isNotEmpty)
        .toSet()
        .toList();
    items.sort();
    return ['الكل', ...items];
  }

  List<Daily> _filteredDailies() {
    if (_locationFilter == 'الكل') return widget.dailies;
    return widget.dailies
        .where((d) => d.businessLocation == _locationFilter)
        .toList();
  }

  num _totalSales(Daily d) {
    return d.cashSales + d.bankSales + d.fawrySales + d.accountSales;
  }

  num _totalCosts(Daily d) {
    return d.spiceCosts +
        d.cashCosts +
        d.bankCosts +
        d.fawryCosts +
        d.accountCosts;
  }

  void _showDetails(Daily d) {
    final sales = _totalSales(d);
    final costs = _totalCosts(d);
    final profit = sales - costs;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تفاصيل اليومية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التاريخ: ${d.date.toIso8601String().split('T').first}'),
            Text('الموقع: ${d.businessLocation}'),
            const SizedBox(height: 6),
            Text('المبيعات: ${numberFormatter(sales)}'),
            Text('التكاليف: ${numberFormatter(costs)}'),
            Text('صافي الربح: ${numberFormatter(profit)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إغلاق'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = _locationOptions();
    final rows = _filteredDailies();
    final totalSales = rows.fold<num>(0, (sum, d) => sum + _totalSales(d));
    final totalCosts = rows.fold<num>(0, (sum, d) => sum + _totalCosts(d));
    final totalProfit = totalSales - totalCosts;

    return Column(
      children: [
        Row(
          children: [
            const Text('فلترة الموقع:'),
            const SizedBox(width: 8),
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                initialValue: options.contains(_locationFilter)
                    ? _locationFilter
                    : 'الكل',
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                items: options
                    .map((l) => DropdownMenuItem(
                          value: l,
                          child: Text(l),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _locationFilter = v);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.teal.shade100),
            ),
            child: Text(
              'إجمالي صافي الربح: ${numberFormatter(totalProfit)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: rows.isEmpty
              ? const Center(child: Text('لا توجد سجلات'))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          border: TableBorder.all(
                            color: Colors.teal.shade100,
                            width: 1,
                          ),
                          columnSpacing: 18,
                          headingRowHeight: 42,
                          dataRowMinHeight: 40,
                          dataRowMaxHeight: 48,
                          headingRowColor:
                              MaterialStateProperty.all(Colors.teal.shade50),
                          dataRowColor: MaterialStateProperty.resolveWith(
                            (states) => states.contains(MaterialState.selected)
                                ? Colors.teal.shade50
                                : Colors.white,
                          ),
                          columns: const [
                            DataColumn(
                                label: Text(
                              'التاريخ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'مجموع المبيعات',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'التكاليف',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'صافي الربح',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'الموقع',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            DataColumn(
                                label: Text(
                              'عرض',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                          ],
                          rows: [
                            ...rows.map((d) {
                              final sales = _totalSales(d);
                              final costs = _totalCosts(d);
                              final profit = sales - costs;
                              return DataRow(cells: [
                                DataCell(Text(
                                  d.date.toIso8601String().split('T').first,
                                  style: const TextStyle(fontSize: 17),
                                )),
                                DataCell(Text(
                                  numberFormatter(sales),
                                  style: const TextStyle(fontSize: 17),
                                )),
                                DataCell(Text(
                                  numberFormatter(costs),
                                  style: const TextStyle(fontSize: 17),
                                )),
                                DataCell(Text(
                                  numberFormatter(profit),
                                  style: const TextStyle(fontSize: 17),
                                )),
                                DataCell(Text(
                                  d.businessLocation,
                                  style: const TextStyle(fontSize: 17),
                                )),
                                DataCell(IconButton(
                                  icon: const Icon(Icons.visibility,
                                      color: Colors.teal),
                                  onPressed: () => _showDetails(d),
                                  tooltip: 'عرض',
                                )),
                              ]);
                            }).toList(),
                            DataRow(
                              color: MaterialStateProperty.all(
                                  Colors.teal.shade50),
                              cells: [
                                const DataCell(Text('الإجمالي',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17))),
                                DataCell(Text(numberFormatter(totalSales),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17))),
                                DataCell(Text(numberFormatter(totalCosts),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17))),
                                DataCell(Text(numberFormatter(totalProfit),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17))),
                                const DataCell(Text('-')),
                                const DataCell(Text('-')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
