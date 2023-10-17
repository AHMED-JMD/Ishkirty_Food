import 'package:ashkerty_food/models/speicies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:ashkerty_food/static/deleteModal.dart';
class SpeiciesTable extends StatefulWidget {
  final List data;

  SpeiciesTable({Key? key, required this.data}) : super(key: key);

  @override
  State<SpeiciesTable> createState() => _SpeiciesTableState(data: data);
}

class _SpeiciesTableState extends State<SpeiciesTable> {
  List data;
  _SpeiciesTableState({required this.data});


  var rowsPerPage = 10;
  late final source = ExampleSource(data: data, context: context);
  final _searchController = TextEditingController();

  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _searchController.text = '';
  }
  //server side Functions ------------------
  //------delete--
  Future deleteBank() async {
    setState(() {
      isLoading = true;
    });
  }

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
                  label: Text('الأسم',style: TextStyle(fontSize: 20),),
                ),
                DataColumn(
                  label: Text('السعر',style: TextStyle(fontSize: 20),),
                ),
                DataColumn(
                  label: Text('الصورة',style: TextStyle(fontSize: 20),),
                ),
                DataColumn(
                  label: Text('النوع',style:TextStyle(fontSize: 20),),
            ),
                  DataColumn(
                  label: Text('.',style:TextStyle(color: Colors.white),),
                  ),
                 ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Spiecies> {
  List data;
  BuildContext context;
  ExampleSource({required this.data, required this.context});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(

        cells: [
          DataCell(
              Text(currentRowData.name,style: const TextStyle(fontSize: 20),)
          ),
          DataCell(
              Text(currentRowData.price,style: const TextStyle(fontSize: 20),)
          ),
          DataCell(
              Text(currentRowData.imageLink ,style: const TextStyle(fontSize: 20),)
          ),
          DataCell(
              Text(currentRowData.type ,style: const TextStyle(fontSize: 20),),

          ),
    DataCell(Padding(
            padding: const EdgeInsets.all(0),
            child: ButtonBar(
              children: [
                IconButton(onPressed: (){} ,icon:const Icon(Icons.mode_edit_outline),tooltip: 'تعديل',),
                IconButton(onPressed: (){}, icon: const Icon(Icons.delete_rounded),tooltip: 'حذف'),
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
  Future<RemoteDataSourceDetails<Spiecies>> getNextPage(
      NextPageRequest pageRequest) async {

    await Future.delayed(const Duration(seconds: 1));
    return RemoteDataSourceDetails(
      All.length,
      All
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize).cast<Spiecies>()
          .toList(),
      filteredRows: lastSearchTerm.isNotEmpty
          ? All.length
          : null, //again in a real world example you would only get the right amount of rows
    );
  }
}
//selected list goes here
List<String> selectedIds = [];

