import 'package:ashkerty_food/API/Client.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/Printing.dart';
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
  List clients = [];
  String? clientID;
  String? payment_method;
  DateTime date = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    getClients();
    super.initState();
  }

  //server fun add bill
  Future addBill (data) async {
    setState(() {
      isLoading = true;
    });

    final response = await APIBill.Add(data);
    setState(() {
      isLoading = false;
    });

    if(response.statusCode == 200) {
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
                child: Text("تم حفظ الفاتورة بنجاح", style: TextStyle(fontSize: 22, color: Colors.white),)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          )
      );
    }else{
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
                child: Text("sorry something is wrong :(", style: TextStyle(fontSize: 22),)),
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
  //server fun get clients
  Future getClients () async {
    setState(() {
      // isLoading = true;
      clients = [];
    });

    final response = await APIClient.Get();

    if(response != false){
      setState(() {
        isLoading = false;
        clients = response;
      });
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
    return Consumer<AuthProvider>(builder: (context, user_val, child){
      return Consumer<CartProvider>(builder: (context, value, child){
        var totalAmount = sumTotal(value.cart);

        return Container(
          color: Colors.blueGrey[300],
          width: MediaQuery.of(context).size.width/3.3,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(isLoading) Container(
                  color: Colors.lightGreen,
                  padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('جاري المعالجة', style: TextStyle(color: Colors.black),),
                      SpinKitThreeBounce(
                        color: Colors.black,
                        size: 40,
                      ),
                    ],
                  ),
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
                          initialValue: 'كاش',
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
                            setState(() {
                              payment_method = value;
                              if(value != 'حساب')
                                clientID = null;
                            });
                          },
                          validator: FormBuilderValidators.required(errorText: "الرجاء اختيار طريقة الدفع"),
                        ),
                        SizedBox(height: 15,),
                        if(payment_method == 'حساب')
                          FormBuilderDropdown(
                            name: "acoount_name",
                            decoration: InputDecoration(
                                labelText: 'اختر الحساب',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.yellow.shade900)
                                )
                            ),
                            items: clients
                                .map((client) => DropdownMenuItem(
                                value: client['id'],
                                child: Text(client['name'])
                            )).toList(),
                            onChanged: (value){
                              if(value != null){
                                clientID = value.toString();
                              }
                            },
                          ),
                        SizedBox(height: 45,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              height: 40,
                              child: ElevatedButton.icon(
                                onPressed: (){
                                  if(_formKey.currentState!.saveAndValidate()) {
                                    //increment bill counter
                                    final cartProvider = context.read<CartProvider>();
                                    cartProvider.increment_counter();

                                    var data = {};
                                    data['date'] = date.toIso8601String();
                                    data['amount'] = totalAmount;
                                    data['trans'] = value.cart;
                                    data['paymentMethod'] = _formKey.currentState!.value['payment_method'];
                                    data['shiftTime'] =
                                    _formKey.currentState!.value['shift'];
                                    data['clientId'] = clientID;
                                    data['admin_id'] = user_val.user['id'];

                                    addBill(data,);
                                    //call printing func
                                    PrintingFunc(value.counter, user_val.user, data);
                                    //reset cart
                                    cartProvider.resetCart();
                                  }
                                },
                                icon: Icon(Icons.paypal),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal
                                ),
                                label: Text('دفع الفاتورة'),
                              ),
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
    });
  }
}
