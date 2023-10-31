import 'package:flutter/material.dart';
import '../../static/my_icon_icons.dart';
Checkout(BuildContext context){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      int ? CurrentPaymentMethod = 1;
      return Padding(
        padding: const EdgeInsets.fromLTRB(250,662,250,0),
        child: Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10.0)),

          child: Directionality(
            textDirection: TextDirection.rtl,
              child: Container(

                height: 150,width: 310,
                decoration: BoxDecoration(
                  color: const Color(0xfff1f1f1),
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
               child: Column(

                 mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children : [

                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height:70),
                          Radio(value: 0, groupValue: CurrentPaymentMethod , onChanged: (value) {
                            setState(() => CurrentPaymentMethod = value);
                          },
                          ),
                          const SizedBox(width: 5,),
                          Icon( Icons.attach_money_rounded,
                            color: Color(0xff1b3b0b),
                            size: 40,),
                          const SizedBox(width: 30,),
                          Radio(value:1, groupValue: CurrentPaymentMethod , onChanged: (value) {

                            setState(() => CurrentPaymentMethod = value);

                          },
                          ),
                          const SizedBox(width: 5,),
                          const Icon(
                            MyIcon.bankak,
                            color: Color(0xffc90000),
                            size: 40,
                          ),
                          const SizedBox(width: 30,),
                          Radio(value: 2, groupValue: CurrentPaymentMethod , onChanged: (value) {

                            setState(() => CurrentPaymentMethod = value);

                          },
                          ),
                          const SizedBox(width: 5,),
                          const Icon(
                            Icons.person_pin,
                            size: 40,
                            color: Color(0xff0c283f),
                          ),

                        ],);
                    }
                  ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                        FilledButton(onPressed: (){}, child: Text('دفع الفاتورة',style: TextStyle(fontSize:16,color: Colors.black),)),
                        SizedBox(width: 20,),
                        FilledButton(onPressed: (){}, child: Text('عرض الفاتورة',style: TextStyle(fontSize:16,color: Colors.black,),))
                      ],
                    ),

                  ],),
              ),

          ),
        ),
      );
    },
  );
}