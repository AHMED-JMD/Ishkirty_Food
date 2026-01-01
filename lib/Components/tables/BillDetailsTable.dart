import 'package:ashkerty_food/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class BilldetailsTable extends StatefulWidget {
  final List data;
  const BilldetailsTable({Key? key, required this.data}) : super(key: key);

  @override
  State<BilldetailsTable> createState() => _BilldetailsTableState();
}

class _BilldetailsTableState extends State<BilldetailsTable> {
  var rowsPerPage = 10;
  late final source = ExampleSource(data: widget.data, context: context);
  final _searchController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }
  //server side Functions ------------------
//-------------------------------------

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
                  label: Center(
                      child: Text(
                    'الصنف ',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                  label: Center(
                      child: Text(
                    'الكمية',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                  label: Center(
                      child: Text(
                    'سعر الوحدة ',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                  label: Center(
                      child: Text(
                    'السعر الكلي ',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Sales> {
  List data;
  BuildContext context;
  ExampleSource({required this.data, required this.context});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(Text(
        currentRowData.name,
        style: const TextStyle(fontSize: 20),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
        child: Text(
          currentRowData.quantity.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
        child: Text(
          currentRowData.price.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
        child: Text(
          currentRowData.amount.toString(),
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
  Future<RemoteDataSourceDetails<Sales>> getNextPage(
      NextPageRequest pageRequest) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return RemoteDataSourceDetails(
      data.length,
      (data)
          .map((json) => Sales.fromJson(json))
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(),
      filteredRows: lastSearchTerm.isNotEmpty
          ? data.length
          : null, //again in a real world example you would only get the right amount of rows
    );
  }
}

//selected list goes here
List<String> selectedIds = [];
