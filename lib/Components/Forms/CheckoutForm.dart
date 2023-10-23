import 'package:flutter/material.dart';
import '../../static/my_icon_icons.dart';
Checkout(BuildContext context){
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      var PaymentMethod ;
      return Padding(
        padding: const EdgeInsets.fromLTRB(550,700,550,8),
        child: Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
          child: Directionality(
            textDirection: TextDirection.rtl,
              child: Column(
              children: [
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                     Radio<int>(
                        value: 1,
                        groupValue: PaymentMethod,
                        activeColor: Color(0xff1b3b0b), // Change the active radio button color here
                        fillColor: MaterialStateProperty.all(Color(0xff68c736)), // Change the fill color when selected
                        splashRadius: 20, // Change the splash radius when clicked
                        onChanged: (value) {
                           {
                             PaymentMethod = value;
                          }
                        },
                      ),

                    Radio<int>(
                        value: 2,
                        groupValue: PaymentMethod,
                        activeColor: Color(0xffc90000), // Change the active radio button color here
                        fillColor: MaterialStateProperty.all(Color(0xffd05252)), // Change the fill color when selected
                        splashRadius: 25, // Change the splash radius when clicked
                        onChanged: (value) {
                           {
                             PaymentMethod = value;
                          }
                        },
                      ),
                    Radio<int>(
                        value: 3,
                        groupValue: PaymentMethod,
                        activeColor: Color(0xff0c283f), // Change the active radio button color here
                        fillColor: MaterialStateProperty.all(Color(0xff3f89c0)), // Change the fill color when selected
                        splashRadius: 25, // Change the splash radius when clicked
                        onChanged: (value) {
                          {
                            PaymentMethod = value;
                          }
                        },
                      ),

                  ],
                ),

              Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  border: Border.all(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextButton(onPressed: (){}, child: Text("دفع الفاتورة",style: TextStyle(color: Colors.black),)),
                Divider(color: Colors.black,thickness: 50,height: 3,),
                TextButton(onPressed: (){},  child: Text("عرض الفاتورة",style: TextStyle(color: Colors.black),)),
                  ],
                ),
              ),
              ],
              ),

          ),
        ),
      );
    },
  );
}