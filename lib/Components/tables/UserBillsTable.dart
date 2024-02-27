import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/API/Transfer.dart';
import 'package:ashkerty_food/models/Bill.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../widgets/BillDetailes.dart';
import 'dart:convert';

class UserBillsTable extends StatefulWidget {
  final String admin_id;

  UserBillsTable({Key? key, required this.admin_id}) : super(key: key);

  @override
  State<UserBillsTable> createState() => _UserBillsTableState();
}

class _UserBillsTableState extends State<UserBillsTable> {
  bool isLoading = false;
  List data = [];
  int transfer = 0;

  @override
  void initState() {
    // TODO: implement initState
    getBills(widget.admin_id);
    getTransfers();
    super.initState();
  }

  //server side Functions ------------------
  //server func to get bills
  Future getBills(admin_id) async {
    setState(() {
      isLoading = true;
    });

    //call server
    Map dataBody = {};
    dataBody['admin_id'] = admin_id;

    final response = await APIBill.getAdminBills(dataBody);

    final datas = jsonDecode(response.body);
    setState(() {
      isLoading = false;
      data = datas;
    });
  }
  //get transfers
  Future getTransfers() async {
    setState(() {
      isLoading = true;
    });
    //call server
    Map datass = {};
    datass['date'] = DateTime.now().toIso8601String();
    datass['adminId'] = widget.admin_id;
    final response = await API_Transfer.Get(datass);

    final transferV = jsonDecode(response.body);

    setState(() {
      isLoading = false;
      transfer = transferV;
    });
  }
  //search dates
  Future searchDates(datas) async {
    setState(() {
      isLoading = true;
      data = [];
    });

    //server call
    Map<String, dynamic> mod_datas = {};

    mod_datas['start_date'] = datas['start_date'];
    mod_datas['end_date'] = datas['end_date'];
    mod_datas['isDeleted'] = false;
    mod_datas['admin_id'] = widget.admin_id;

    final response = await APIBill.Search(mod_datas);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
        // Call updateData method to update data in ExampleSource
        source.updateData(res);
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
//-------------------------------------

  var rowsPerPage = 10;
  late final source = ExampleSource(
    context: context,
    data: data,
  );

//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SearchInDates(searchDates: searchDates),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    color: Colors.red[300],
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text('تحويلات اليوم = $transfer',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 15,),
            data.length != 0 || isLoading == false ?
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
                      label:  Text(
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
                  ],
                ) : Center(
                      child: SpinKitPouringHourGlassRefined(
                        color: Colors.teal,
                        size: 37,
                      ),
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
  ExampleSource(
      {required this.context, required this.data});

  String lastSearchTerm = '';

  //update data when searched
  void updateData(List newData){
    data = newData;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    //setting date & time
    var now = DateTime.parse(currentRowData.createdAt);
    String date = '${now.year}/${now.month}/${now.day}';
    String time = '${now.hour}:${now.minute}';
    String amPm = now.hour > 12 ? 'PM': 'AM';

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
                  builder: (context) => BillDetailes(
                    billId: currentRowData.id,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('التفاصيل', style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
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

    if (data.length > 0) {
      return RemoteDataSourceDetails(
          data.length,
          (data as List<dynamic>)
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
