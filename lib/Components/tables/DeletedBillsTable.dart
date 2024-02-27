import 'package:ashkerty_food/Components/Forms/DeleteBill.dart';
import 'package:ashkerty_food/models/Bill.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import '../../widgets/BillDetailes.dart';


class DeletedBillsTable extends StatefulWidget {
  final List data;
  DeletedBillsTable({Key? key, required this.data}) : super(key: key);

  @override
  State<DeletedBillsTable> createState() => _DeletedBillsTableState(data: data);

}

class _DeletedBillsTableState extends State<DeletedBillsTable> {
  List data;
  _DeletedBillsTableState({required this.data});


  var rowsPerPage = 10;
  late final source = ExampleSource(data: data, context: context);
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
    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            AdvancedPaginatedDataTable(
              addEmptyRows: false,
              source: source,
              showFirstLastButtons: true,
              rowsPerPage: rowsPerPage,
              availableRowsPerPage: const [ 5, 10, 25],
              onRowsPerPageChanged: (newRowsPerPage) {
                if (newRowsPerPage != null) {
                  setState(() {
                    rowsPerPage = newRowsPerPage;
                  });
                }
              },
              columns: const [
                DataColumn(
                    label: Text('التعليق',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label: Text('تفاصيل الفاتورة',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label:  Text('وقت الفاتورة',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label:  Text(' قيمة الفاتورة ',style: TextStyle(fontSize: 20),),
                ),
                DataColumn(
                    label: Text(' طريقة الدفع',style: TextStyle(fontSize: 20),),
                ),
                DataColumn(
                    label:  Text(' الوردية',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label:  Text('',style: TextStyle(color: Color(0xffffffff)),)
                ),
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

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    //setting date & time
    var now = DateTime.parse(currentRowData.createdAt);
    String date = '${now.year}/${now.month}/${now.day}';
    String time = '${now.hour}:${now.minute}';
    String amPm = now.hour > 12 ? 'PM': 'AM';

    return DataRow(
        cells: [
          DataCell(
               Text(currentRowData.comment.toString(),style: const TextStyle(fontSize: 20),),
          ),
          DataCell(
             ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillDetailes(billId: currentRowData.id),
                  ),
                );
              },
               style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.teal
               ),
               child: const Text('التفاصيل',style:TextStyle(fontSize: 20)),),
            ),
          DataCell(
              Text('($time $amPm) - $date',style: const TextStyle(fontSize: 20),)
          ),
          DataCell(
               Center(child: Text(currentRowData.amount.toString(),style: const TextStyle(fontSize: 20),)),
          ),
          DataCell(
               Center(child: Text(currentRowData.paymentMethod,style: const TextStyle(fontSize: 20),)),
          ),
          DataCell(
               Text(currentRowData.shiftTime,style: const TextStyle(fontSize: 20),),
          ),
          DataCell(
              DeleteBills(id: currentRowData.id,)
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
    return RemoteDataSourceDetails(
      data.length,
        (data as List<dynamic>)
        .map((json) => bill.fromJson(json))
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

