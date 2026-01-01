import 'package:ashkerty_food/API/Client.dart';
import 'package:ashkerty_food/models/Client.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

import 'package:ashkerty_food/widgets/ClientTransactios.dart';
import 'package:ashkerty_food/Components/Forms/UpdateAccountForm.dart';
import 'package:ashkerty_food/Components/Forms/DeleteAccountForm.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ClientTable extends StatefulWidget {
  final List data;
  const ClientTable({Key? key, required this.data}) : super(key: key);
  @override
  State<ClientTable> createState() => _ClientTableState();
}

class _ClientTableState extends State<ClientTable> {
  //server side Functions ------------------
  //modify account
  Future Modify(data) async {
    setState(() {
      isLoading = true;
    });
    // call server
    final response = await APIClient.Modify(data);

    setState(() {
      isLoading = false;
    });
    if (response == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text(
          'تمت تعديل البيانات بنجاح',
          style: TextStyle(fontSize: 19),
        )),
        backgroundColor: Colors.green,
      ));
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/clients');
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

  //modify account
  Future Delete(data) async {
    setState(() {
      isLoading = true;
    });
    // call server
    final response = await APIClient.Delete(data);

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
      Navigator.pushReplacementNamed(context, '/clients');
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
  late final source = ExampleSource(
      data: widget.data, context: context, modify: Modify, delete: Delete);
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
                  label: Center(
                      child: Text(
                    'رقم العميل',
                    style: TextStyle(fontSize: 20),
                  )),
                ),
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
                    'الحساب',
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

class ExampleSource extends AdvancedDataTableSource<Client> {
  List data;
  BuildContext context;
  final Function(Map) modify;
  final Function(Map) delete;
  ExampleSource(
      {required this.data,
      required this.context,
      required this.modify,
      required this.delete});

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
      DataCell(Text(
        currentRowData.name,
        style: const TextStyle(fontSize: 20),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 11, 8),
        child: Text(
          currentRowData.account.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientTransactios(
                    clientId: currentRowData.id,
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
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.all(0),
          child: OverflowBar(
            children: [
              TextButton.icon(
                  onPressed: () {
                    AddAccount(
                      data: currentRowData,
                      Modify: modify,
                    ).AddModal(context);
                  },
                  label: const Text('تعديل الحساب'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  icon: const Icon(
                    Icons.edit,
                  )),
              IconButton(
                  onPressed: () {
                    DeleteAccount(
                      data: currentRowData,
                      Delete: delete,
                    ).Modal(context);
                  },
                  icon: Icon(Icons.delete_rounded, color: Colors.red.shade900),
                  tooltip: 'حذف'),
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
  Future<RemoteDataSourceDetails<Client>> getNextPage(
      NextPageRequest pageRequest) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return RemoteDataSourceDetails(
      data.length,
      (data)
          .map((json) => Client.fromJson(json))
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
