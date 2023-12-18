import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ashkerty_food/API/Bill.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/static/my_icon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class CartForm extends StatefulWidget {
  CartForm({super.key});

  @override
  State<CartForm> createState() => _CartFormState();
}

class _CartFormState extends State<CartForm> {

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  String? payment_method;
  DateTime date = DateTime.now();

  //server fun call
  Future addBill (data) async {
    setState(() {
      isLoading = true;
    });

    final response = await APIBill.Add(data);

    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      final data = jsonDecode(response.body);
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Center(child: Text(data, style: TextStyle(fontSize: 19),)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "close X",
              onPressed: (){
                Navigator.pop(context);
                },
          ),
        )
      );
    }else{
      setState(() {
        isLoading = false;
      });

      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("sorry something is wrong :(", style: TextStyle(fontSize: 19),),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: "close X",
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          )
      );
    }
  }

  //function to get total cart value
  sumTotal (List cart ) {
    num sum = 0;
    for(int i =0; i< cart.length; i++){
      sum += cart[i].total_price;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    // date time check
    DateTime currentTime = DateTime.now();
    DateTime sixPM = DateTime(currentTime.year, currentTime.month, currentTime.day, 18, 0, 0);

    bool isAfterSixPM = currentTime.isAfter(sixPM);
    //----------
    return Consumer<CartProvider>(builder: (context, value, child){
      var totalAmount = sumTotal(value.cart);

      return Container(
        color: Colors.blueGrey[300],
        width: 400,
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(isLoading) SpinKitThreeBounce(
                color: Colors.black,
                size: 40,
              ),
              SizedBox(height: 20,),
              Text('اختر طريقة الدفع', textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 19,
                  color: Colors.white
              ),
              ),
              SizedBox(height: 15,),
              FormBuilder(
                key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormBuilderRadioGroup(
                        initialValue: isAfterSixPM ? 'مسائية' : 'صباحية',
                        enabled: false,
                        name: 'shift',
                        decoration: InputDecoration(
                            labelText: 'الوردية', contentPadding: EdgeInsets.all(10.0),
                        ),
                        options: [
                          FormBuilderFieldOption(
                              value: 'صباحية',
                              child: Text('صباحية', style: TextStyle(fontSize: 18, ),),
                          ),
                          FormBuilderFieldOption(
                              value: 'مسائية',
                              child: Text('مسائية', style: TextStyle(fontSize: 18, ),),
                          ),
                        ],
                        validator: FormBuilderValidators.required(errorText: "الرجاء اختيار الوردية"),
                      ),
                      SizedBox(height: 20,),
                      FormBuilderRadioGroup(
                        name: 'payment_method',
                        decoration: InputDecoration(
                            labelText: 'اختر طريقة الدفع', contentPadding: EdgeInsets.all(10.0)),
                        options: [
                          FormBuilderFieldOption(
                            value: 'كاش',
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Icon(Icons.monetization_on, color: Colors.green[900], size: 50, ),
                            ),
                          ),
                          FormBuilderFieldOption(
                            value: 'بنكك',
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Icon(MyIcon.bankak, color: Colors.red[900], size: 50,),
                            ),
                          ),
                          FormBuilderFieldOption(
                            value: 'حساب',
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Icon(Icons.account_box, color: Colors.blue[900], size: 50,),
                            ),
                          ),
                        ],
                        onChanged: (value){
                          payment_method = value;
                        },
                        validator: FormBuilderValidators.required(errorText: "الرجاء اختيار طريقة الدفع"),
                      ),
                      SizedBox(height: 45,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (){
                              if(_formKey.currentState!.saveAndValidate()){
                                var data = {};
                                data['date'] = date.toIso8601String();
                                data['amount'] = totalAmount;
                                data['trans'] = value.cart;
                                data['paymentMethod'] = payment_method;
                                data['shiftTime'] = _formKey.currentState!.value['shift'];

                                addBill(data);
                              }
                            },
                            icon: Icon(Icons.paypal),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal
                            ),
                            label: Text('دفع الفاتورة'),
                          ),
                          ElevatedButton.icon(
                            onPressed: (){},
                            icon: Icon(Icons.print),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal
                            ),
                            label: Text('طباعة الفاتورة'),
                          ),
                        ],
                      ),
                    ],
                  )
              ),

              SizedBox(height: 40),
              Text('عدد الاصناف = ${value.cart.length}', textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 19,
                  color: Colors.white
              ),
              ),
              Text("المبلغ الكلي: ${totalAmount}", textAlign: TextAlign.center,style: TextStyle(
                  fontSize: 30,
                  color: Colors.white
              ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
