import 'package:ashkerty_food/API/Auth.dart';
import 'package:ashkerty_food/models/manager.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

import 'package:ashkerty_food/widgets/ManagerDetails.dart';
import 'package:ashkerty_food/Components/Forms/DeleteManager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ManagerTable extends StatefulWidget {
  final List data;
  const ManagerTable({Key? key, required this.data}) : super(key: key);
  @override
  State<ManagerTable> createState() => _ManagerTableState();
}

class _ManagerTableState extends State<ManagerTable> {
  //server side Functions ------------------
  //delete account
  Future Delete(data) async {
    setState(() {
      isLoading = true;
    });
    // call server
    final response = await APIAuth.DeleteManager(data);

    setState(() {
      isLoading = false;
    });
    if (response == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text(
          'تمت الحذف بنجاح',
          style: TextStyle(fontSize: 19),
        )),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/profile');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text(
          '$response',
          style: const TextStyle(fontSize: 19),
        )),
        backgroundColor: Colors.red,
      ));
    }
  }
//-------------------------------------

  var rowsPerPage = 10;
  late final source =
      ExampleSource(data: widget.data, context: context, delete: Delete);
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
            isLoading == true
                ? const SpinKitWave(
                    color: Colors.green,
                    size: 40.0,
                  )
                : const Text(''),
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
                    label: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 35, 8),
                  child: Text(
                    'الأسم',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
                DataColumn(
                  label: Center(
                      child: Text(
                    'رقم الهاتف',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                  label: Center(
                      child: Text(
                    'الوردية',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                  label: Center(
                      child: Text(
                    'المعاملات',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                DataColumn(
                    label: Center(
                        child: Text(
                  '',
                  style: TextStyle(color: Color(0xffffffff)),
                ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Managers> {
  List data;
  BuildContext context;
  final Function(Map) delete;
  ExampleSource(
      {required this.data, required this.context, required this.delete});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Text(
            currentRowData.username,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      DataCell(Text(
        currentRowData.phoneNum.toString(),
        style: const TextStyle(fontSize: 20),
      )),
      DataCell(
        Text(
          currentRowData.shift,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManagerDetails(
                  adminId: currentRowData.adminId,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.feed_outlined,
            color: Color(0xffb2a011),
          ),
          tooltip: 'معاملات',
        ),
      ),
      DataCell(DeleteManager(
        data: currentRowData,
        Delete: delete,
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
  Future<RemoteDataSourceDetails<Managers>> getNextPage(
      NextPageRequest pageRequest) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return RemoteDataSourceDetails(
      data.length,
      (data)
          .map((json) => Managers.fromJson(json))
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
