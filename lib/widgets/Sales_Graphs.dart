import 'package:flutter/material.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';
import 'SpeciesStats.dart';

class  SalesGRaphs extends StatelessWidget {
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
  Navigator.pushReplacementNamed(context, '/orders');
  },
  ),
  title: const Center(child:Text("الرسوم البيانيية", style: TextStyle(fontSize: 25,)),),
  actions: const [LeadingDrawerBtn(),],

  ),
  endDrawer:const MyDrawer(),

),


  );
  }
}
