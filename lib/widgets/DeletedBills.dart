import 'package:ashkerty_food/static/drawer.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import '../Components/tables/DeletedBillsTable.dart';
import '../static/SearchDeletedDates.dart';

class DeletedBills extends StatefulWidget {
  const DeletedBills({super.key});

  @override
  State<DeletedBills> createState() => _DeletedBillsState();
}

class _DeletedBillsState extends State<DeletedBills> {

  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  DateTime? start_date = DateTime.now();
  DateTime? end_date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xff20491a),
          //custom button in static folder
          leading: IconButton(
            icon: const Icon(
              Icons.home_sharp,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          title: const Center(child: Text("الفواتير المحذوفة", style: TextStyle(fontSize: 25),)),
          actions: const [LeadingDrawerBtn(),],
          toolbarHeight: 45,
        ),

        //custom drawer in static folder
        endDrawer: const MyDrawer(),

        body: ListView(
            children:[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //custom widget in static folder for showing search bar responsive
                  const SearchInDeletedDates(),

                  const SizedBox(height: 10,),
                  Container(
                      color: Colors.grey[100],
                      child: DeletedBillsTable(data: [],)
                  ),
                ],
              ),
            ]
        ),

      ),
    );
  }
}
