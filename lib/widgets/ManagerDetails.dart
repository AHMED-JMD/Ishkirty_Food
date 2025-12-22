import 'package:ashkerty_food/Components/tables/UserBillsTable.dart';
import 'package:ashkerty_food/widgets/Profile.dart';
import 'package:flutter/material.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';

class  ManagerDetails extends StatefulWidget {
  final adminId;
  ManagerDetails({super.key, required this.adminId});

  @override
  State<ManagerDetails> createState() => _ManagerDetailsState();
}

class _ManagerDetailsState extends State<ManagerDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff20491a),
          leading:  IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 37,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  UserProfile(),
                ),
              );
            },
          ),
          title: const Center(child:Text(" فواتير الكاشير", style: TextStyle(fontSize: 25,)),),
          actions: const [LeadingDrawerBtn(),],
          toolbarHeight: 45,
        ),
        endDrawer:const MyDrawer(),
        body: ListView(
            children:[
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey[100]
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60,),
                  Container(
                      color: Colors.grey[100],
                      child: UserBillsTable(admin_id: widget.adminId,)
                  )
                ],
              ),
            ]
        ),
      ),
    );
  }
}
