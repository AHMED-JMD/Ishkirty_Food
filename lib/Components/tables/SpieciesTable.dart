import 'package:ashkerty_food/models/speicies.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:intl/intl.dart';
import '../Forms/AddSpeiciesForm.dart';
import '../Forms/DeleteSpeicies.dart';
import '../Forms/EditSpeiciesForm.dart';

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

class ExampleSource extends AdvancedDataTableSource<Spieces> {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,5,8),
                child: Text(currentRowData.price.toString(),style: const TextStyle(fontSize: 20),),
              )
          ),
          DataCell(
              Text(currentRowData.ImgLink ,style: const TextStyle(fontSize: 20),)
          ),
          DataCell(
              Text(currentRowData.category ,style: const TextStyle(fontSize: 20),),

          ),
    DataCell(Padding(
            padding: const EdgeInsets.all(0),
            child: ButtonBar(
              children: [
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => EditSpieces(data: currentRowData,))
                  );
                  },
                  icon: Icon(Icons.mode_edit_outline,color: Color(0xff0d4f0c),),tooltip: 'تعديل',),
                IconButton(onPressed: (){
                  DeleteSpices().deletespeices(context);
                  },
                    icon: const Icon(Icons.delete_rounded,color: Color(0xff65090c),),tooltip: 'حذف'),
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

    await Future.delayed(const Duration(seconds: 1));
    return RemoteDataSourceDetails(
      data.length,
      (data as List<dynamic>)
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

