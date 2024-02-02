import 'dart:convert';
import 'package:ashkerty_food/API/Auth.dart';
import 'package:ashkerty_food/Components/Forms/AddAdminForm.dart';
import 'package:ashkerty_food/Components/Forms/ChangePassword.dart';
import 'package:ashkerty_food/Components/tables/ManagersTable.dart';
import 'package:ashkerty_food/Components/tables/UserBillsTable.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/leadinButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List data = [];
  List managers = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getManagers();
  }

  //function to get managers
  Future getManagers() async {
    setState(() {
      isLoading = true;
    });
    //call server
    final response = await APIAuth.GetManagers();

    final datas = jsonDecode(response.body);

    setState(() {
      isLoading = false;
      managers = datas;
    });
  }
  //function to add new admin
  Future addAdmin(data) async {
    setState(() {
      isLoading = true;
    });
    //call server
    final response = await APIAuth.Register(data);
    setState(() {
      isLoading = false;
    });

    // call get managers again to get new data
    getManagers();

    if(response.statusCode ==200){
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Center(
              child: Text('تمت اضافة مستخدم جديد بنجاح', style: TextStyle(fontSize: 22),),
            ),
            backgroundColor: Colors.green,
        )
      );

    } else{
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('${response.body}', style: TextStyle(fontSize: 22),),
            ),
            backgroundColor: Colors.red,
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, value, child){
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            leading:  IconButton(
              icon: Icon(
                Icons.home_work,
                size: 37,
                color: Colors.white,
              ),
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            title: Center(child:Text("الملف الشخصي", style: TextStyle(fontSize: 25,)),),
            actions: [LeadingDrawerBtn(),],
            toolbarHeight: 45,
          ),
          endDrawer: const MyDrawer(),
          body: ListView(
            children: [
              Container(
                color: Colors.tealAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('مرحبا,', style: TextStyle(fontSize: 23, color: Colors.grey),),
                        SizedBox(width: 10,),
                        Text('${value.user['username']}', style: TextStyle(fontSize: 30, color: Colors.black),)
                      ],
                    ),
                    SizedBox(height: 10,),
                    value.user['role'] != 'admin' ?
                      ChangePassword(admin_id: value.user['id'])
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChangePassword(admin_id: value.user['id']),
                            SizedBox(width: 20,),
                            Add_Admin(addAdmin: addAdmin)
                        ],
                      ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              SizedBox(height: 80,),
              data.length != 0 || isLoading == false
                  ? Container(
                    color: Colors.grey[100],
                    child: value.user['role'] != 'admin' ?
                    Column(
                      children: [
                        Center(
                          child: Text('الفواتير المحررة اليوم', style: TextStyle(fontSize: 26, color: Colors.black),),
                        ),
                        SizedBox(height: 20,),
                        UserBillsTable(admin_id: value.user['id']),
                      ],
                    ) : Column(
                      children: [
                        Center(
                          child: Text('الكاشيرز', style: TextStyle(fontSize: 26, color: Colors.black),),
                        ),
                        SizedBox(height: 20,),
                        ManagerTable(data: managers),
                      ],
                    )
              )
                  : Padding(
                  padding: const EdgeInsets.only(top: 190.0),
                  child: SpinKitPouringHourGlassRefined(
                  color: Colors.teal,
                  size: 70.0,
                ),
              ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      );
    });
  }
}
