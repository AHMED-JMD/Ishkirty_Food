import 'package:flutter/material.dart';
import '../static/drawer.dart';
import '../static/leadinButton.dart';

class  SalesGRaphs extends StatefulWidget {
  @override
  State<SalesGRaphs> createState() => _SalesGRaphsState();
}

class _SalesGRaphsState extends State<SalesGRaphs> {
  int ? _period = 1;
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [const SizedBox(height: 94,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1.8,
                    height: MediaQuery.of(context).size.height/1.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.red,
                      shape: BoxShape.rectangle,
                    ),
                    child: const Center(child: Text('!!STILL UNDER TEST NOW',style: TextStyle(color: Colors.white, fontSize: 22),)),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height:100),
                  Radio(value: 1, groupValue: _period, onChanged: (value) {
                    setState(() {
                      _period = value;
                    });
                  },
                  ),
                  const SizedBox(width: 5,),
                  Text ('اسبوع'),
                  const SizedBox(width: 30,),
                  Radio(value: 2, groupValue: _period, onChanged: (Value) {
                    setState(() {
                      _period = Value;
                    });
                  },
                  ),
                  const SizedBox(width: 5,),
                  const Text ('شهر'),
                  const SizedBox(width: 30,),
                  Radio(value: 3, groupValue: _period, onChanged: (Value) {
                    setState(() {
                      _period = Value;
                    });
                  },
                  ),
                  const SizedBox(width: 5,),
                  Text ('سنة'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
