import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/models/speicies.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Forms/DeleteSpeicies.dart';
import '../Forms/EditSpeiciesForm.dart';

class SpeiciesTable extends StatefulWidget {
  final Map admin;
  final List data;

  const SpeiciesTable({Key? key, required this.admin, required this.data})
      : super(key: key);

  @override
  State<SpeiciesTable> createState() => _SpeiciesTableState();
}

class _SpeiciesTableState extends State<SpeiciesTable> {
  var rowsPerPage = 10;
  late final source = ExampleSource(
      admin: widget.admin,
      data: widget.data,
      context: context,
      delete: deleteSpieces);
  final _searchController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }

  //server side Functions ------------------
  //------delete--
  Future deleteSpieces(data) async {
    setState(() {
      isLoading = true;
    });
    //call the api
    final response = await APISpieces.Delete(data);
    setState(() {
      isLoading = false;
    });

    if (response == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text(
          'تمت حذف الصنف بنجاح',
          style: TextStyle(fontSize: 19),
        )),
        backgroundColor: Colors.green,
      ));

      await Future.delayed(const Duration(milliseconds: 400));
      Navigator.pushReplacementNamed(context, '/speices');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text('$response', style: const TextStyle(fontSize: 19))),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

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
                    size: 50.0,
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
                  label: Text(
                    'الأسم',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'السعر',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'النوع',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DataColumn(
                  label: Row(
                    children: [
                      Text(
                        'التكلفة',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.monetization_on, color: Colors.teal),
                    ],
                  ),
                ),
                DataColumn(
                  label: Text(
                    'الزر',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Spieces> {
  final Map admin;
  List data;
  BuildContext context;
  final Function(Map) delete;
  ExampleSource(
      {required this.admin,
      required this.data,
      required this.context,
      required this.delete});

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
        padding: const EdgeInsets.fromLTRB(8, 8, 5, 8),
        child: Text(
          numberFormatter(currentRowData.price),
          style: const TextStyle(fontSize: 20),
        ),
      )),
      DataCell(
        Text(
          currentRowData.category,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          Text(
            numberFormatter(currentRowData.spiceCost),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.money_off)
        ],
      )),
      DataCell(Text(
          currentRowData.isControll
              ? 'ctrl + ${currentRowData.favBtn}'
              : currentRowData.favBtn,
          style: const TextStyle(fontSize: 20))),
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
                          builder: (context) => EditSpieces(
                                data: currentRowData,
                              )));
                },
                icon: const Icon(
                  Icons.mode_edit_outline,
                  color: Color(0xff0d4f0c),
                ),
                tooltip: 'تعديل',
              ),
              admin['role'] == 'admin'
                  ? IconButton(
                      onPressed: () {
                        DeleteSpices(
                          delete: delete,
                          data: currentRowData,
                        ).deletespeices(context);
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Color(0xff65090c),
                      ),
                      tooltip: 'حذف')
                  : const SizedBox.shrink(),
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
  Future<RemoteDataSourceDetails<Spieces>> getNextPage(
      NextPageRequest pageRequest) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return RemoteDataSourceDetails(
      data.length,
      (data)
          .map((json) => Spieces.fromJson(json))
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
