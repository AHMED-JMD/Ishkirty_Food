import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/models/Bill.dart';
import 'package:ashkerty_food/static/SearchDates.dart';
import 'package:ashkerty_food/widgets/DeletedBills.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../widgets/BillDetailes.dart';
import 'package:ashkerty_food/Components/Forms/DeleteBill.dart';
import 'dart:convert';

class billTable extends StatefulWidget {
  billTable({
    Key? key,
  }) : super(key: key);

  @override
  State<billTable> createState() => _billTableState();
}

class _billTableState extends State<billTable> {
  List data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "offset": "0",
      "pageSize": "10"
    };
    getBills(headers);
  }

  //server side Functions ------------------
  //server func to get bills
  Future getBills(headers) async {
    setState(() {
      isLoading = true;
    });

    //call server
    Map dataBody = {};
    dataBody['isDeleted'] = false;

    final response = await APIBill.GetAll(dataBody, headers);
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final datas = jsonDecode(response.body);
      setState(() {
        data = datas;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  //search dates
  Future searchDates(datas) async {
    setState(() {
      isLoading = true;
      data = [];
    });

    //server call
    Map mod_datas = {};
    mod_datas['start_date'] = datas['start_date'];
    mod_datas['end_date'] = datas['end_date'];
    mod_datas['isDeleted'] = false;

    final response = await APIBill.Search(mod_datas);
    //response validity
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);

      setState(() {
        isLoading = false;
        data = res;
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
    getBills: getBills,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SearchInDates(searchDates: searchDates),
                Row(
                  children: [
                    // PrintPage(),
                    SizedBox(
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
                        label: Text('الفواتير المحذوفة'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        icon: Icon(
                          Icons.delete_forever_sharp,
                          size: 30,
                          color: Colors.black,
                        )),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            isLoading == true
                ? Center(
                    child: SpinKitPouringHourGlassRefined(
                      color: Colors.teal,
                      size: 60,
                    ),
                  )
                : AdvancedPaginatedDataTable(
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
                          label: Padding(
                        padding: EdgeInsets.only(right: 35),
                        child: Text(
                          ' قيمة الفاتورة ',
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                      DataColumn(
                          label: Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          ' طريقة الدفع',
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                      DataColumn(
                          label: Text(
                        ' الوردية',
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
  Function(Map) getBills;
  List data;
  ExampleSource(
      {required this.context, required this.getBills, required this.data});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
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
        currentRowData.date,
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
      DataCell(
        Padding(
          padding: const EdgeInsets.all(0),
          child: ButtonBar(
            children: [
              DeleteBill(
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
    // await Future.delayed(const Duration(milliseconds: 400));

    final Map<String, String> reqHeaders = {
      "Content-Type": "application/json",
      "offset": pageRequest.offset.toString(),
      "pageSize": pageRequest.pageSize.toString()
    };

    //call server for data
    // getBills(reqHeaders);
    if (data.length > 0) {
      return RemoteDataSourceDetails(data.length,
          (data as List<dynamic>).map((json) => bill.fromJson(json)).toList());
    } else {
      throw Exception('Unable to query remote server');
    }
  }
}

//selected list goes here
List<String> selectedIds = [];
