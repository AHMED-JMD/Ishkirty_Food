import 'package:ashkerty_food/models/sales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:ashkerty_food/static/deleteModal.dart';

class SalesTable extends StatefulWidget {
  final List data;
  SalesTable({Key? key, required this.data}) : super(key: key);

  @override
  State<SalesTable> createState() => _SalesTableState(data: data);
}

class _SalesTableState extends State<SalesTable> {
  List data;
  _SalesTableState({required this.data});


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
    //send to server
    // if (selectedIds.length != 0) {
    //   final auth = await SharedServices.LoginDetails();
    //   API_Bank.Delete_Bank(selectedIds, auth.token).then((response) async {
    //     setState(() {
    //       isLoading = false;
    //     });
    //
    //     if (response == true) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('تم الحذف بنجاح', textAlign: TextAlign.center,
    //             style: TextStyle(fontSize: 17),),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //       await Future.delayed(Duration(milliseconds: 600));
    //       Navigator.pushReplacementNamed(context, '/banks');
    //       selectedIds = [];
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('$response', textAlign: TextAlign.center,
    //             style: TextStyle(fontSize: 17),),
    //           backgroundColor: Colors.red,
    //         ),
    //       );
    //       selectedIds = [];
    //     }
    //   });
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         'الرجاء اختيار بنك من الجدول', textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 17),),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }
//-------------------------------------

  //delete modal

//--------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints ){
                if(constraints.maxWidth > 700){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 5,),
                      TextButton.icon(
                        onPressed: (){
                          // _deleteModal(context);
                        } ,
                        icon: Icon(Icons.delete),
                        label: Text(''),
                      ),
                    ],
                  );
                }else{
                  return Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 5,),
                          TextButton.icon(
                            onPressed: (){
                              // _deleteModal(context);
                            } ,
                            icon: Icon(Icons.delete),
                            label: Text(''),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 20,),
            AdvancedPaginatedDataTable(
              addEmptyRows: false,
              source: source,
              showFirstLastButtons: true,
              rowsPerPage: rowsPerPage,
              availableRowsPerPage: [ 5, 10, 25],
              onRowsPerPageChanged: (newRowsPerPage) {
                if (newRowsPerPage != null) {
                  setState(() {
                    rowsPerPage = newRowsPerPage;
                  });
                }
              },
              columns: [
                DataColumn(
                  label: const Text('الرقم'),
                ),
                DataColumn(
                  label: const Text('اسم الصنف'),
                ),
                DataColumn(
                  label: const Text('النوع'),
                ),
                DataColumn(
                  label: const Text('السعر'),
                ),
                DataColumn(
                  label: const Text('التاريخ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<Sales> {
  List data;
  BuildContext context;
  ExampleSource({required this.data, required this.context});

  String lastSearchTerm = '';

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(
        selected: selectedIds.contains(currentRowData.id),
        onSelectChanged: (selected) {
          if(selected != null){
            selectedRow(currentRowData.id, selected);
          }
        },
        cells: [
          DataCell(
              Text(currentRowData.id,)
          ),
          DataCell(
              Text(currentRowData.name,)
          ),
          DataCell(
            Text(currentRowData.type,),
          ),
          DataCell(
            Text(currentRowData.price.toString(),),
          ),
          DataCell(
            Text(currentRowData.date,),
          ),
          // DataCell(
          //   InkWell(
          //     onTap: (){
          //       Navigator.push(context, MaterialPageRoute(
          //           builder: (context) => BanksDetails(banks_id: currentRowData.banks_id)));
          //     },
          //     child: Icon(Icons.remove_red_eye, color:  Colors.grey.shade500,),
          //   ),
          // ),
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
  Future<RemoteDataSourceDetails<Sales>> getNextPage(
      NextPageRequest pageRequest) async {

    await Future.delayed(Duration(seconds: 1));
    return RemoteDataSourceDetails(
      sales.length,
      sales
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(),
      filteredRows: lastSearchTerm.isNotEmpty
          ? sales.length
          : null, //again in a real world example you would only get the right amount of rows
    );
  }
}
//selected list goes here
List<String> selectedIds = [];

