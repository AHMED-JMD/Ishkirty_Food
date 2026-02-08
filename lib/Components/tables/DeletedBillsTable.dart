import 'package:ashkerty_food/Components/Forms/DeleteBill.dart';
import 'package:ashkerty_food/models/Bill.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import '../../widgets/BillDetailes.dart';

class DeletedBillsTable extends StatefulWidget {
  final List data;
  const DeletedBillsTable({Key? key, required this.data}) : super(key: key);

  @override
  State<DeletedBillsTable> createState() => _DeletedBillsTableState();
}

class _DeletedBillsTableState extends State<DeletedBillsTable> {
  String _paymentFilter = 'الكل';
  var rowsPerPage = 10;
  late final source = ExampleSource(data: widget.data, context: context);
  final _searchController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  ' طرق الدفع : ',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  width: 5,
                ),
                DropdownButton<String>(
                  value: _paymentFilter,
                  items: const [
                    DropdownMenuItem(
                        value: 'الكل',
                        child: Text(
                          'الكل',
                          style: TextStyle(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'كاش',
                        child: Text(
                          'كاش',
                          style: TextStyle(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'بنكك',
                        child: Text(
                          'بنكك',
                          style: TextStyle(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'فوري',
                        child: Text(
                          'فوري',
                          style: TextStyle(fontSize: 18),
                        )),
                  ],
                  onChanged: (v) {
                    final next = v ?? 'الكل';
                    setState(() {
                      _paymentFilter = next;
                    });
                    source.setPaymentFilter(next);
                  },
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 10),
            AdvancedPaginatedDataTable(
              addEmptyRows: false,
              source: source,
              showFirstLastButtons: true,
              rowsPerPage: rowsPerPage,
              availableRowsPerPage: const [5, 10, 25],
              onRowsPerPageChanged: (newRowsPerPage) {
                if (newRowsPerPage != null) {
                  setState(() {
                    rowsPerPage = newRowsPerPage;
                  });
                }
              },
              columns: const [
                DataColumn(
                    label: Text(
                  'التعليق',
                  style: TextStyle(fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'الادمن',
                  style: TextStyle(fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  ' الوردية',
                  style: TextStyle(fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'تفاصيل الفاتورة',
                  style: TextStyle(fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  'وقت الفاتورة',
                  style: TextStyle(fontSize: 20),
                )),
                DataColumn(
                  label: Text(
                    ' قيمة الفاتورة ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DataColumn(
                  label: Text(
                    ' طريقة الدفع',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DataColumn(
                    label: Text(
                  '',
                  style: TextStyle(color: Color(0xffffffff)),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<bill> {
  List data;
  BuildContext context;
  ExampleSource({required this.data, required this.context});
  String _paymentFilter = 'الكل';

  void setPaymentFilter(String value) {
    _paymentFilter = value;
    setNextView();
  }

  String _paymentText(bill row) {
    final single = row.paymentMethod;

    if (single != null && single.trim().isNotEmpty) {
      return single;
    }
    final methods = row.paymentMethods;
    if (methods != null && methods.isNotEmpty) {
      return methods
          .map((m) => '${m.method}: ${numberFormatter(m.amount)}')
          .join(' , ');
    }
    return 'غير محدد';
  }

  bool _matchesPaymentFilter(bill row) {
    if (_paymentFilter == 'الكل') return true;
    final normalizedFilter = _paymentFilter.trim();

    final single = row.paymentMethod;
    if (single != null && single.trim() == normalizedFilter) {
      return true;
    }

    final methods = row.paymentMethods;
    if (methods != null && methods.isNotEmpty) {
      return methods.any((m) => m.method.trim() == normalizedFilter);
    }

    return false;
  }

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    //setting date & time
    var now = DateTime.parse(currentRowData.createdAt);
    String date = '${now.year}/${now.month}/${now.day}';
    String time = '${now.hour}:${now.minute}';
    String amPm = now.hour > 12 ? 'PM' : 'AM';

    return DataRow(cells: [
      DataCell(
        Text(
          currentRowData.comment.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 5, 8),
        child: Text(
          currentRowData.admin != null
              ? currentRowData.admin.toString()
              : 'لايوجد',
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(
        Text(
          currentRowData.shiftTime,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      DataCell(
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BillDetailes(billId: currentRowData.id.toString()),
              ),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          child: const Text('التفاصيل',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
      DataCell(Text(
        '($time $amPm) - $date',
        style: const TextStyle(fontSize: 20),
      )),
      DataCell(
        Center(
            child: Text(
          currentRowData.amount.toString(),
          style: const TextStyle(fontSize: 20),
        )),
      ),
      DataCell(
        Text(
          _paymentText(currentRowData),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      DataCell(DeleteBills(
        id: currentRowData.id,
      )),
    ]);
  }

  @override
  int get selectedRowCount => selectedIds.length;

  void selectedRow(String id, bool newSelectState) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void filterServerSide(String filterQuery) {
    lastSearchTerm = filterQuery.toLowerCase().trim();
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<bill>> getNextPage(
      NextPageRequest pageRequest) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final bills = (data).map((json) => bill.fromJson(json)).toList();
    final filtered = bills.where(_matchesPaymentFilter).toList();

    return RemoteDataSourceDetails(
      filtered.length,
      filtered.skip(pageRequest.offset).take(pageRequest.pageSize).toList(),
      filteredRows: lastSearchTerm.isNotEmpty ? filtered.length : null,
    );
  }
}

//selected list goes here
List<String> selectedIds = [];
