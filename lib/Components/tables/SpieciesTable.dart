import 'package:ashkerty_food/models/speicies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:ashkerty_food/static/deleteModal.dart';
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,650,20),
                  child: Container(height:50,width:250,
                      decoration:BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: TextField(decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: () {  }, icon: Icon(Icons.search_sharp,size: 24,color: Color(0xff090c2d),),)
                      ),
                      )

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,10),
                  child: IconButton(onPressed: (){AddSpeicies_Modal(context);}, icon: Icon(Icons.add_box_sharp,color: Color(0xff090c2d),size: 25,)),
                ),
              ],
            ),
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
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
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
                child: Text(myFormat.format(currentRowData.price),style: const TextStyle(fontSize: 20),),
              )
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
                IconButton(onPressed: (){EditSpeicies_Modal(context,Spiecies(name: "مشكل", type: "juice", price: 1300, imageLink: "juice.jpg"),);} ,icon:const Icon(Icons.mode_edit_outline,color: Color(0xff0d4f0c),),tooltip: 'تعديل',),
                IconButton(onPressed: (){deletespeices(context,'as');}, icon: const Icon(Icons.delete_rounded,color: Color(0xff65090c),),tooltip: 'حذف'),
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

