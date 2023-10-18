import 'package:ashkerty_food/models/Client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:ashkerty_food/static/deleteModal.dart';
import 'package:intl/intl.dart';
class ClientTable extends StatefulWidget {
  final List data;
  ClientTable({Key? key, required this.data}) : super(key: key);
  @override
  State<ClientTable> createState() => _ClientTableState(data: data);
}

class _ClientTableState extends State<ClientTable> {
  List data;
  _ClientTableState({required this.data});


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
                  label: Center(child: Text('رقم العميل',style: TextStyle(fontSize: 20),)),
                ),
                DataColumn(
                  label:  Padding(
                    padding: EdgeInsets.fromLTRB(8,8,35,8),
                    child: Text('الأسم',style: TextStyle(fontSize: 20),),
                  )
                ),
                DataColumn(
                  label: Center(child: Text('الحساب',style: TextStyle(fontSize: 20),)),
                ),
                DataColumn(
                   label: Center(child: Text('',style: TextStyle(color: Color(0xffffffff)),))
                
                ),
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
  ExampleSource({required this.data, required this.context});

  String lastSearchTerm = '';

  @override
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(

        cells: [
          DataCell(
               Padding(
                 padding: const EdgeInsets.fromLTRB(8,8,50,8),
                 child: Text(currentRowData.id,style: const TextStyle(fontSize: 20),),
               )
          ),
          DataCell(
              Text(currentRowData.name,style: const TextStyle(fontSize: 20),)
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,11,8),
              child: Text(myFormat.format(currentRowData.account),style: const TextStyle(fontSize: 20),),
            )
          ),
          DataCell(
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: ButtonBar(
                    children: [
                      IconButton(onPressed: (){} ,icon:const Icon(Icons.add_box_sharp),tooltip: 'إضافة',),
                      IconButton(onPressed: (){}, icon:const Icon(Icons.remove_circle_sharp),tooltip: 'خصم'),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.delete_rounded),tooltip: 'حذف'),
                    ],
                  ),
                ),

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
  Future<RemoteDataSourceDetails<Client>> getNextPage(
      NextPageRequest pageRequest) async {

    await Future.delayed(const Duration(seconds: 1));
    return RemoteDataSourceDetails(
      Clients.length,
      Clients
          .skip(pageRequest.offset)
          .take(pageRequest.pageSize)
          .toList(),
      filteredRows: lastSearchTerm.isNotEmpty
          ? Clients.length
          : null, //again in a real world example you would only get the right amount of rows
    );
  }
}
//selected list goes here
List<String> selectedIds = [];

