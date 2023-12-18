import 'package:ashkerty_food/models/Bill.dart';
import 'package:flutter/material.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import '../../widgets/BilDeatles.dart';


class DeletedBillsTable extends StatefulWidget {
  final List data;
  DeletedBillsTable({Key? key, required this.data}) : super(key: key);

  @override
  State<DeletedBillsTable> createState() => _DeletedBillsTableState(data: data);

}

class _DeletedBillsTableState extends State<DeletedBillsTable> {
  List data;
  _DeletedBillsTableState({required this.data});


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
                    label: Text('رقم الفاتورة',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label: Text('تفاصيل الفاتورة',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label:  Text('وقت الفاتورة',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label:  Padding(
                      padding: EdgeInsets.only(right: 35),
                      child: Text(' قيمة الفاتورة ',style: TextStyle(fontSize: 20),),
                    )
                ),
                DataColumn(
                    label:  Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Text(' طريقة الدفع',style: TextStyle(fontSize: 20),),
                    )
                ),
                DataColumn(
                    label:  Text(' الوردية',style: TextStyle(fontSize: 20),)
                ),
                DataColumn(
                    label:  Text('',style: TextStyle(color: Color(0xffffffff)),)

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExampleSource extends AdvancedDataTableSource<bill> {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,50,8),
                child: Text(currentRowData.bill_id,style: const TextStyle(fontSize: 20),),
              )
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.fromLTRB(8,8,16,0),
              child: ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillDeatles(),
                  ),
                );
              }, child: const Text('التفاصيل',style:TextStyle(fontSize: 20)),),
            ),
          ),
          DataCell(
              Text(currentRowData.date,style: const TextStyle(fontSize: 20),)
          ),
          DataCell(
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 25, 8),
                child: Center(child: Text(currentRowData.amount.toString(),style: const TextStyle(fontSize: 20),)),
              )
          ),
          DataCell(
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,20,8),
                child: Center(child: Text(currentRowData.paymentMethod,style: const TextStyle(fontSize: 20),)),
              )
          ),
          DataCell(
              Padding(
                padding: const EdgeInsets.fromLTRB(8,8,5,8),
                child: Text(currentRowData.shiftTime,style: const TextStyle(fontSize: 20),),
              )
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.all(0),
              child: ButtonBar(
                children: [
                  IconButton(onPressed: (){} ,icon:const Icon(Icons.message_outlined,color: Color(
                      0xff5d5c05),),tooltip: 'تعديل',),
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
  Future<RemoteDataSourceDetails<bill>> getNextPage(
      NextPageRequest pageRequest) async {

    await Future.delayed(const Duration(seconds: 1));
    return RemoteDataSourceDetails(
      data.length,
        (data as List<dynamic>)
        .map((json) => bill.fromJson(json))
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

