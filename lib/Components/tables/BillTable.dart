import 'package:ashkerty_food/models/Bill.dart';
import 'package:ashkerty_food/widgets/DeletedBills.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import '../../widgets/BillDetailes.dart';
import 'package:ashkerty_food/Components/Forms/DeletedBillsAdd.dart';

class billTable extends StatefulWidget {
  final List data;
  const billTable({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<billTable> createState() => _billTableState();
}

class _billTableState extends State<billTable> {
  @override
  void initState() {
    super.initState();
  }

//-------------------------------------

  var rowsPerPage = 10;
  late final source = ExampleSource(
    context: context,
    data: widget.data,
  );

//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeletedBills(),
                        ),
                      );
                    },
                    label: const Text(
                      'الفواتير المحذوفة',
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      size: 30,
                      color: Colors.black,
                    )),
              ],
            ),
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
                    label: Text(
                  'رقم الفاتورة',
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
                  ' الوردية',
                  style: TextStyle(fontSize: 20),
                )),
                DataColumn(
                    label: Text(
                  ' الادمن',
                  style: TextStyle(fontSize: 20),
                )),
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
  BuildContext context;
  List data;
  ExampleSource({required this.context, required this.data});

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
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 50, 8),
        child: Text(
          currentRowData.id.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(Text(
        '($time $amPm) - $date',
        style: const TextStyle(fontSize: 20),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
        child: Center(
            child: Text(
          currentRowData.amount.toString(),
          style: const TextStyle(fontSize: 20),
        )),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
        child: Center(
            child: Text(
          currentRowData.paymentMethod,
          style: const TextStyle(fontSize: 20),
        )),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 5, 8),
        child: Text(
          currentRowData.shiftTime,
          style: const TextStyle(fontSize: 20),
        ),
      )),
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
        Padding(
          padding: const EdgeInsets.all(0),
          child: OverflowBar(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BillDetailes(
                        billId: currentRowData.id.toString(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.more_outlined),
                tooltip: 'التفاصيل',
              ),
              AddToDeleted(
                bill: currentRowData,
              )
            ],
          ),
        ),
      ),
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

    if (data.isNotEmpty) {
      return RemoteDataSourceDetails(
          data.length,
          (data)
              .map((json) => bill.fromJson(json))
              .skip(pageRequest.offset)
              .take(pageRequest.pageSize)
              .toList());
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}

//selected list goes here
List<String> selectedIds = [];
