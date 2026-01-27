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
  bool isSecondPrinter = false;
  bool isDelivery = false;
  List clients = [];
  String? clientID;
  String? payment_method;
  DateTime date = DateTime.now();
  String deliveryAddress = "";
  num deliveryCost = 0;

  @override
  void initState() {
    getClients();
    super.initState();
  }

  //server fun add bill
  Future addBill(data) async {
    setState(() {
      isLoading = true;
    });

    final response = await APIBill.Add(data);
    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(
            child: Text(
          "تم حفظ الفاتورة بنجاح",
          style: TextStyle(fontSize: 22, color: Colors.white),
        )),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ));
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Center(
            child: Text(
          "${response.body}",
          style: const TextStyle(fontSize: 22),
        )),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "close X",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ));
    }
  }

  //server fun get clients
  Future getClients() async {
    setState(() {
      // isLoading = true;
      clients = [];
    });

    final response = await APIClient.Get();

    if (response != false) {
      setState(() {
        isLoading = false;
        clients = response;
      });
    }
  }

  //function to get total cart value
  sumTotal(List cart) {
    num sum = 0;
    for (int i = 0; i < cart.length; i++) {
      sum += cart[i].total_price;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isPhone = width < 600;

    double fontSize({required double desktopCalc, required double mobile}) {
      return isPhone ? mobile : desktopCalc;
    }

    // date time check
    DateTime currentTime = DateTime.now();
    DateTime sixPM = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 18, 0, 0);

    bool isAfterSixPM = currentTime.isAfter(sixPM);
    //----------
    return Consumer<AuthProvider>(builder: (context, userVal, child) {
      return Consumer<CartProvider>(builder: (context, value, child) {
        var totalAmount = sumTotal(value.cart);

        Widget inner = Container(
          color: Colors.blueGrey[300],
          // avoid using double.infinity inside modal/unbounded parents
          // use the measured screen width instead
          width: isPhone ? width : width / 3.3,
          // avoid forcing full height on phones so modal can size itself
          height: isPhone ? height : height,
          child: Padding(
            padding: EdgeInsets.only(
                top: 20.0, left: 20, right: 20, bottom: isPhone ? 20 : 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (isLoading)
                  Container(
                    color: Colors.lightGreen,
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 2, bottom: 2),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'جاري المعالجة',
                          style: TextStyle(color: Colors.black),
                        ),
                        SpinKitThreeBounce(
                          color: Colors.black,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'اختر طريقة الدفع',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fontSize(desktopCalc: width / 50, mobile: 23),
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderRadioGroup(
                          initialValue: isAfterSixPM ? 'مسائية' : 'صباحية',
                          enabled: false,
                          name: 'shift',
                          decoration: const InputDecoration(
                            labelText: 'الوردية',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          options: [
                            FormBuilderFieldOption(
                              value: 'صباحية',
                              child: Text(
                                'صباحية',
                                style: TextStyle(
                                  fontSize: fontSize(
                                      desktopCalc: width / 90, mobile: 17),
                                ),
                              ),
                            ),
                            FormBuilderFieldOption(
                              value: 'مسائية',
                              child: Text(
                                'مسائية',
                                style: TextStyle(
                                  fontSize: fontSize(
                                      desktopCalc: width / 90, mobile: 17),
                                ),
                              ),
                            ),
                          ],
                          validator: FormBuilderValidators.required(
                              errorText: "الرجاء اختيار الوردية"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormBuilderRadioGroup(
                          name: 'payment_method',
                          initialValue: 'بنكك',
                          decoration: const InputDecoration(
                              labelText: 'اختر طريقة الدفع',
                              contentPadding: EdgeInsets.all(10.0)),
                          options: [
                            FormBuilderFieldOption(
                              value: 'بنكك',
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Icon(
                                  MyIcon.bankak,
                                  color: Colors.red[900],
                                  size: fontSize(
                                      desktopCalc: width / 40, mobile: 40),
                                ),
                              ),
                            ),
                            FormBuilderFieldOption(
                              value: 'كاش',
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Icon(
                                  Icons.monetization_on,
                                  color: Colors.green[900],
                                  size: fontSize(
                                      desktopCalc: width / 40, mobile: 40),
                                ),
                              ),
                            ),
                            FormBuilderFieldOption(
                              value: 'حساب',
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Icon(
                                  Icons.account_box,
                                  color: Colors.blue[900],
                                  size: fontSize(
                                      desktopCalc: width / 40, mobile: 40),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              payment_method = value;
                              if (value != 'حساب') clientID = null;
                            });
                          },
                          validator: FormBuilderValidators.required(
                              errorText: "الرجاء اختيار طريقة الدفع"),
                        ),
                        if (payment_method == 'حساب')
                          FormBuilderDropdown(
                            name: "acoount_name",
                            decoration: InputDecoration(
                                labelText: 'اختر الحساب',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellow.shade900))),
                            items: clients
                                .map((client) => DropdownMenuItem(
                                    value: client['id'],
                                    child: Text(client['name'])))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                clientID = value.toString();
                              }
                            },
                          ),
                        const SizedBox(
                          height: 15,
                        ),
                        // FormBuilderCheckbox(
                        //     name: 'secPrinter',
                        //     ...existing code...
                        //     )),

                        Transform.scale(
                          scale: isPhone ? 1.2 : 1.0,
                          alignment: Alignment.centerLeft,
                          child: FormBuilderCheckbox(
                            name: 'isDelivery',
                            initialValue: isDelivery,
                            title: Text(
                              'توصيل؟',
                              style: TextStyle(
                                  fontSize: fontSize(
                                      desktopCalc: width / 90, mobile: 16)),
                            ),
                            onChanged: (val) {
                              setState(() {
                                isDelivery = val ?? false;
                                if (!isDelivery) {
                                  deliveryCost = 0;
                                  deliveryAddress = "";
                                }
                              });
                            },
                          ),
                        ),
                        if (isDelivery)
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'delivery_cost',
                                initialValue: deliveryCost != 0
                                    ? deliveryCost.toString()
                                    : '',
                                decoration: const InputDecoration(
                                  labelText: 'تكلفة التوصيل',
                                ),
                                keyboardType: TextInputType.number,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'ادخل تكلفة التوصيل'),
                                  FormBuilderValidators.numeric(
                                      errorText: 'ادخل رقم صحيح'),
                                ]),
                                onChanged: (val) {
                                  setState(() {
                                    deliveryCost =
                                        num.tryParse(val ?? '0') ?? 0;
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              FormBuilderTextField(
                                name: 'delivery_address',
                                initialValue: deliveryAddress,
                                decoration: const InputDecoration(
                                  labelText: 'عنوان التوصيل',
                                ),
                                validator: FormBuilderValidators.required(
                                    errorText: 'ادخل عنوان التوصيل'),
                                onChanged: (val) {
                                  setState(() {
                                    deliveryAddress = val ?? '';
                                  });
                                },
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              // avoid double.infinity inside unbounded parents; use available screen width minus padding
                              width: isPhone ? (width - 40) : width / 7.1,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (_formKey.currentState!
                                          .saveAndValidate() &&
                                      value.cart.length != 0) {
                                    //increment bill counter
                                    final cartProvider =
                                        context.read<CartProvider>();
                                    cartProvider.increment_counter();

                                    var data = {};
                                    data['date'] = date.toIso8601String();
                                    data['amount'] = totalAmount;
                                    data['trans'] = value.cart;
                                    data['paymentMethod'] = _formKey
                                        .currentState!.value['payment_method'];
                                    data['shiftTime'] =
                                        _formKey.currentState!.value['shift'];
                                    data['clientId'] = clientID;
                                    data['admin_id'] = userVal.user['id'];
                                    // Delivery fields
                                    data['isDelivery'] = isDelivery;
                                    data['delivery_cost'] =
                                        isDelivery ? (deliveryCost) : 0;
                                    data['delivery_address'] =
                                        isDelivery ? (deliveryAddress) : "";

                                    addBill(data);
                                    // print cashier + client copies
                                    // PrintingFunc('XP-80C', value.counter,
                                    //     userVal.user, data,
                                    //     includeLabel: true,
                                    //     labelText: 'كوبون استلام');
                                    // small delay can help the printer process first job before sending second
                                    // await Future.delayed(
                                    //     const Duration(milliseconds: 200));
                                    // // client copy without label
                                    // PrintingFunc('XP-80C', value.counter,
                                    //     userVal.user, data,
                                    //     includeLabel: false);

                                    await printTwoCopies('Save to PDF',
                                        value.counter, userVal.user, data,
                                        cashierLabel: 'كوبون استلام');
                                    // if configured, send same pair to second printer as well
                                    if (isSecondPrinter) {
                                      await printTwoCopies('XP-80C',
                                          value.counter, userVal.user, data,
                                          cashierLabel: 'كوبون استلام');
                                    }
                                    //reset cart
                                    cartProvider.resetCart();
                                  }
                                },
                                icon: const Icon(Icons.paypal),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal),
                                label: Text(
                                  'دفع الفاتورة',
                                  style: TextStyle(
                                      fontSize: fontSize(
                                          desktopCalc: width / 80, mobile: 16)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 35),
                Text(
                  'عدد الاصناف = ${value.cart.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fontSize(desktopCalc: width / 80, mobile: 14),
                      color: Colors.black),
                ),
                Text(
                  "المبلغ الكلي: $totalAmount",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fontSize(desktopCalc: width / 50, mobile: 20),
                      color: Colors.black),
                ),
              ],
            ),
          ),
        );

        // If on phone, constrain height so it fits inside the bottom sheet and scrolls when needed
        if (isPhone) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height * 0.92,
                  // constrain width to screen width to avoid infinite/unbounded width errors
                  maxWidth: width,
                ),
                child: inner,
              ),
            ),
          );
        }

        return inner;
      });
    });
  }
}
