
import 'package:ashkerty_food/static/drawer.dart';
import 'package:ashkerty_food/static/spieces_nav.dart';
import 'package:flutter/material.dart';
import '../Components/Forms/TransactForm.dart';
import '../static/HomeDrawerbut.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          //custom button in folder static
          leading: IconButton(
            icon: const Icon(
              Icons.home_sharp,
              size: 37,
              color: Colors.black,
            ),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          toolbarHeight: 50,
title: Image.asset("assets/images/ef1.jpg",
width: 100,
  height: 100,


),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions:  [

              SizedBox(
                width: 77,height: 40,
                child: FilledButton(onPressed:(){Transact(context);},
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(color: Colors.transparent),

        )
      )
    ),child: Text('تحويل',style: TextStyle(fontSize: 16,color: Colors.white),),),
              ),


            SizedBox(width: 30,),
            HomeDrawerbut(),]
        ),
        //custom drawer in static folder
        endDrawer: const MyDrawer(),
        body:  const SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),

                //custom nav in static folder
                SpiecesNav(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
