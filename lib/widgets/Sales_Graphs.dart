import 'package:flutter/material.dart';
import '../Components/Forms/CheckoutForm.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';
import '../static/my_icon_icons.dart';
import 'SpeciesStats.dart';

class  SalesGRaphs extends StatelessWidget {
    List <String> PaymentMethod = ['CASH','BANKAK','ACCOUNT'];
    late String CurrentPaymentMethod = PaymentMethod[0];
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
    toolbarHeight: 45,
  ),
  endDrawer:const MyDrawer(),
),
  );
  }
}
