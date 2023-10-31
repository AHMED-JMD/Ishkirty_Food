import 'package:flutter/material.dart';
import '../../static/my_icon_icons.dart';

Checkout(BuildContext context) {
  List PaymentMethod = ['Bankk', 'Cash', 'Account'];

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      int? CurrentPaymentMethod = 1;
      return Padding(
        padding: const EdgeInsets.fromLTRB(250, 662, 250, 0),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: 350,
              width: 300,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: Icon(
                          Icons.attach_money_rounded,
                          color: Color(0xff1b3b0b),
                          size: 30,
                        ),
                        leading: Radio(
                          value: PaymentMethod[0],
                          groupValue: CurrentPaymentMethod,
                          activeColor: Color(
                              0xff000000), // Change the active radio button color here
                          fillColor: MaterialStateProperty.all(Color(
                              0xff1b3b0b)), // Change the fill color when selected
                          splashRadius:
                              20, // Change the splash radius when clicked
                          onChanged: (value) {
                            {
                              CurrentPaymentMethod = value;
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: Icon(
                          MyIcon.bankak,
                          color: Color(0xffc90000),
                          size: 30,
                        ),
                        leading: Radio(
                          value: PaymentMethod[1],
                          groupValue: CurrentPaymentMethod,
                          activeColor: Color(
                              0xff000000), // Change the active radio button color here
                          fillColor: MaterialStateProperty.all(Color(
                              0xffc90000)), // Change the fill color when selected
                          splashRadius:
                              20, // Change the splash radius when clicked
                          onChanged: (value) {
                            {
                              CurrentPaymentMethod = value;
                            }
                          },
                        ),
                      ),
                      ListTile(
                        title: Icon(
                          Icons.person_pin,
                          size: 30,
                          color: Color(0xff0c283f),
                        ),
                        leading: Radio(
                          value: PaymentMethod[2],
                          groupValue: CurrentPaymentMethod,
                          activeColor: Color(
                              0xff000000), // Change the active radio button color here
                          fillColor: MaterialStateProperty.all(Color(
                              0xff0c283f)), // Change the fill color when selected
                          splashRadius:
                              20, // Change the splash radius when clicked
                          onChanged: (value) {
                            {
                              CurrentPaymentMethod = value;
                            }
                          },
                        ),
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
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "دفع الفاتورة",
                              style: TextStyle(color: Colors.black),
                            )),
                        Divider(
                          color: Colors.black,
                          thickness: 50,
                          height: 3,
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "عرض الفاتورة",
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        //Dialog(
        //   backgroundColor: Colors.transparent,
        //   shape: RoundedRectangleBorder(
        //     borderRadius:
        //     BorderRadius.circular(20.0)),
        //   child: Directionality(
        //     textDirection: TextDirection.rtl,
        //       child: Container(
        //         height: 350,width: 300,
        //         child: Column(
        //         children: [
        //           const SizedBox(height: 10,),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        //      ListTile(
        //        title: Icon(Icons.attach_money_rounded, color: Color(0xff1b3b0b), size: 30,),
        //        leading: Radio(
        //           value: PaymentMethod[0],
        //           groupValue: CurrentPaymentMethod,
        //           activeColor: Color(0xff000000), // Change the active radio button color here
        //           fillColor: MaterialStateProperty.all(Color(0xff1b3b0b)), // Change the fill color when selected
        //           splashRadius: 20, // Change the splash radius when clicked
        //           onChanged: (value) {
        //              {CurrentPaymentMethod = value.toString();
        //             }
        //           },
        //         ),
        //      ),
        //     ListTile(
        //       title: Icon(MyIcon.bankak, color: Color(0xffc90000), size: 30,),
        //       leading: Radio(
        //         value: PaymentMethod[1],
        //         groupValue: CurrentPaymentMethod,
        //         activeColor: Color(0xff000000), // Change the active radio button color here
        //         fillColor: MaterialStateProperty.all(Color(0xffc90000)), // Change the fill color when selected
        //         splashRadius: 20, // Change the splash radius when clicked
        //         onChanged: (value) {
        //           {
        //             CurrentPaymentMethod = value.toString();
        //           }
        //         },
        //       ),
        //     ),
        //     ListTile(
        //       title:Icon(Icons.person_pin, size: 30, color: Color(0xff0c283f),),
        //       leading: Radio(
        //         value: PaymentMethod[2],
        //         groupValue: CurrentPaymentMethod,
        //         activeColor: Color(0xff000000), // Change the active radio button color here
        //         fillColor: MaterialStateProperty.all(Color(0xff0c283f)), // Change the fill color when selected
        //         splashRadius: 20, // Change the splash radius when clicked
        //         onChanged: (value) {
        //           {
        //             CurrentPaymentMethod = value.toString();
        //           }
        //         },
        //       ),
        //     ),
        //
        //   ],
        // ),
        //
        //         Container(
        //           height: 40,
        //           width: 250,
        //           decoration: BoxDecoration(
        //             color: const Color(0xffffffff),
        //             border: Border.all(
        //               width: 2,
        //             ),
        //             borderRadius: BorderRadius.circular(100),
        //           ),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisSize: MainAxisSize.max,
        //             children: [
        //               TextButton(onPressed: (){}, child: Text("دفع الفاتورة",style: TextStyle(color: Colors.black),)),
        //           Divider(color: Colors.black,thickness: 50,height: 3,),
        //           TextButton(onPressed: (){},  child: Text("عرض الفاتورة",style: TextStyle(color: Colors.black),)),
        //             ],
        //           ),
        //         ),
        //         ],
        //         ),
        //       ),
        //
        //   ),
        // ),
      );
    },
  );
}
