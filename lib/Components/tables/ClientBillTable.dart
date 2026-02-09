import 'package:ashkerty_food/models/Bill.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import '../../widgets/BillDetailes.dart';

class ClientBillTable extends StatefulWidget {
  final List data;
  const ClientBillTable({Key? key, required this.data}) : super(key: key);

  @override
  State<ClientBillTable> createState() => _ClientBillTableState();
}

class _ClientBillTableState extends State<ClientBillTable> {
  var rowsPerPage = 10;
  late final source = ExampleSource(data: widget.data, context: context);
  final _searchController = TextEditingController();
  String _typeFilter = 'الكل';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }
  //server side Functions -----------

//-------------------------------------

  //delete modal

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
                  ' النوع : ',
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  width: 5,
                ),
                DropdownButton<String>(
                  value: _typeFilter,
                  items: const [
                    DropdownMenuItem(
                        value: 'الكل',
                        child: Text(
                          'الكل',
                          style: TextStyle(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'سفري',
                        child: Text(
                          'سفري',
                          style: TextStyle(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'محلي',
                        child: Text(
                          'محلي',
                          style: TextStyle(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'توصيل',
                        child: Text(
                          'توصيل',
                          style: TextStyle(fontSize: 18),
                        )),
                    DropdownMenuItem(
                        value: 'استلام',
                        child: Text(
                          'استلام',
                          style: TextStyle(fontSize: 18),
                        )),
                  ],
                  onChanged: (v) {
                    final next = v ?? 'الكل';
                    setState(() {
                      _typeFilter = next;
                    });
                    source.setTypeFilter(next);
                  },
                ),
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
                  'رقم الفاتورة',
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
                )),
                DataColumn(
                    label: Text(
                  ' النوع',
                  style: TextStyle(fontSize: 20),
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
  String _typeFilter = 'الكل';

  String lastSearchTerm = '';

  void setTypeFilter(String value) {
    _typeFilter = value;
    setNextView();
  }

  bool _matchesTypeFilter(bill row) {
    if (_typeFilter == 'الكل') return true;
    final normalizedFilter = _typeFilter.trim();
    final rowType = row.type.toString().trim();
    if (rowType.isEmpty) return false;
    return rowType == normalizedFilter;
  }

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    //setting date & time
    var now = DateTime.parse(currentRowData.createdAt);
    String date = '${now.year}/${now.month}/${now.day}';
    String time = '${now.hour}:${now.minute}';
    String amPm = now.hour > 12 ? 'PM' : 'AM';

    return DataRow(cells: [
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 50, 8),
        child: Text(
          currentRowData.id.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: ElevatedButton(
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
      ),
      DataCell(Text(
        '($time $amPm) - $date',
        style: const TextStyle(fontSize: 20),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 35, 8),
          child: Text(
            currentRowData.amount.toString(),
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 5, 8),
        child: Text(
          currentRowData.type,
          style: const TextStyle(fontSize: 20),
        ),
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
    final filtered = (data)
        .map((json) => bill.fromJson(json))
        .where(_matchesTypeFilter)
        .toList();
    return RemoteDataSourceDetails(
      filtered.length,
      filtered
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(),
      filteredRows: lastSearchTerm.isNotEmpty ? filtered.length : null,
    );
  }
}

//selected list goes here
List<String> selectedIds = [];
