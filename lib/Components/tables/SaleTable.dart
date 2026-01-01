import 'package:ashkerty_food/models/SpieSales.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class SalesTable extends StatefulWidget {
  final List data;
  const SalesTable({Key? key, required this.data}) : super(key: key);

  @override
  State<SalesTable> createState() => _SalesTableState();
}

class _SalesTableState extends State<SalesTable> {
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
                    'الاسم ',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                  label: Center(
                      child: Text(
                    'النوع',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                  label: Center(
                      child: Text(
                    ' الايرادات ',
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

class ExampleSource extends AdvancedDataTableSource<SpiecesSales> {
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
          currentRowData.category,
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
        child: Text(
          currentRowData.totSales.toString(),
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
  Future<RemoteDataSourceDetails<SpiecesSales>> getNextPage(
      NextPageRequest pageRequest) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return RemoteDataSourceDetails(
      data.length,
      (data)
          .map((json) => SpiecesSales.fromJson(json))
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
