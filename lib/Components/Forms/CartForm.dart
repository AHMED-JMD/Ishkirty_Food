import 'package:ashkerty_food/API/Client.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:ashkerty_food/static/Printing.dart';
import 'package:ashkerty_food/static/formatter.dart';
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
  String type = "سفري";
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
        duration: Duration(seconds: 2),
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
        backgroundColor: Colors.red[900],
        duration: const Duration(seconds: 2),
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
                top: 20.0, left: 10, right: 10, bottom: isPhone ? 20 : 0),
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
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'دفع الفاتورة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: fontSize(desktopCalc: width / 60, mobile: 23),
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
                          // initialValue: isAfterSixPM ? 'مسائية' : 'صباحية',
                          name: 'type',
                          decoration: const InputDecoration(
                            labelText: 'نوع الفاتورة',
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          options: [
                            FormBuilderFieldOption(
                              value: 'سفري',
                              child: Text('سفري',
                                  style: TextStyle(
                                      fontSize: fontSize(
                                          desktopCalc: width / 110,
                                          mobile: 40))),
                              // const SizedBox(width: 10),
                              // Icon(
                              //   Icons.flight_takeoff_outlined,
                              //   color: Colors.orange[900],
                              //   size: fontSize(
                              //       desktopCalc: width / 50, mobile: 40),
                              // ),
                            ),
                            FormBuilderFieldOption(
                              value: 'محلي',
                              child: Text('محلي',
                                  style: TextStyle(
                                      fontSize: fontSize(
                                          desktopCalc: width / 110,
                                          mobile: 40))),
                              // const SizedBox(width: 10),
                              // Icon(
                              //   Icons.restaurant,
                              //   size: fontSize(
                              //       desktopCalc: width / 50, mobile: 40),
                              // ),
                            ),
                            FormBuilderFieldOption(
                              value: 'استلام',
                              child: Text('استلام',
                                  style: TextStyle(
                                      fontSize: fontSize(
                                          desktopCalc: width / 110,
                                          mobile: 40))),
                              // const SizedBox(width: 10),
                              // Icon(
                              //   Icons.store,
                              //   size: fontSize(
                              //       desktopCalc: width / 50, mobile: 40),
                              // ),
                            ),
                            FormBuilderFieldOption(
                              value: 'توصيل',
                              child: Text('توصيل',
                                  style: TextStyle(
                                      fontSize: fontSize(
                                          desktopCalc: width / 110,
                                          mobile: 40))),
                              // const SizedBox(width: 10),
                              // Icon(
                              //   Icons.delivery_dining,
                              //   color: Colors.red[900],
                              //   size: fontSize(
                              //       desktopCalc: width / 50, mobile: 40),
                              // ),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              type = val ?? "سفري";
                              if (type != "توصيل") {
                                deliveryCost = 0;
                                deliveryAddress = "";
                              }
                            });
                          },
                          validator: FormBuilderValidators.required(
                              errorText: "الرجاء اختيار نوع الفاتورة"),
                        ),
                        if (type == "توصيل")
                          Column(
                            children: [
                              const SizedBox(height: 5),
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
                              const SizedBox(height: 5),
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
                          height: 10,
                        ),
                        FormBuilderRadioGroup(
                          name: 'payment_method',
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
                                      desktopCalc: width / 50, mobile: 40),
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
                                      desktopCalc: width / 50, mobile: 40),
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
                                      desktopCalc: width / 50, mobile: 40),
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
                        // Small scrollable table of cart items: name, qt, price
                        SizedBox(
                          height: isPhone ? 120 : 180,
                          child: Card(
                            color: Colors.white70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text('الاسم',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      SizedBox(
                                          width: 60,
                                          child: Text('الكمية',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      SizedBox(
                                          width: 80,
                                          child: Text('السعر',
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: value.cart.isEmpty
                                      ? const Center(
                                          child: Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text('لا توجد اصناف'),
                                        ))
                                      : ListView.separated(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          itemCount: value.cart.length,
                                          itemBuilder: (ctx, i) {
                                            final item = value.cart[i];
                                            final name = item.spices ??
                                                (item['spices'] ?? '');
                                            final qty = item.counter ??
                                                (item['counter'] ?? 0);
                                            final price = item.total_price ??
                                                (item['total_price'] ?? 0);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    name.toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                                  SizedBox(
                                                      width: 60,
                                                      child: Text(
                                                        qty.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                  SizedBox(
                                                      width: 80,
                                                      child: Text(
                                                        price.toString(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      )),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (_, __) =>
                                              const Divider(height: 1),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'عدد  = ${value.cart.length}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSize(
                                  desktopCalc: width / 110, mobile: 14),
                              color: Colors.black),
                        ),
                        Text(
                          "المبلغ : ${numberFormatter(totalAmount)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize:
                                  fontSize(desktopCalc: width / 80, mobile: 20),
                              color: Colors.white),
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
                                    //counter logic
                                    String billCounter = value.counter <= 100
                                        ? "A${value.counter}"
                                        : value.counter <= 200
                                            ? "B${value.counter - 100}"
                                            : "C${value.counter - 200}";

                                    var data = {};
                                    data['bill_counter'] = billCounter;
                                    data['date'] = date.toIso8601String();
                                    data['amount'] = totalAmount;
                                    data['trans'] = value.cart;
                                    data['paymentMethod'] = _formKey
                                        .currentState!.value['payment_method'];
                                    // data['shiftTime'] =
                                    //     _formKey.currentState!.value['shift'];
                                    data['shiftTime'] =
                                        isAfterSixPM ? 'مسائية' : 'صباحية';
                                    data['type'] =
                                        _formKey.currentState!.value['type'];
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
                                    // PrintingFunc('XP-80C', billCounter,
                                    //     userVal.user, data,
                                    //     includeLabel: true,
                                    //     labelText: 'كوبون استلام');
                                    // small delay can help the printer process first job before sending second
                                    // // client copy without label
                                    // PrintingFunc('XP-80C', billCounter,
                                    //     userVal.user, data,
                                    //     includeLabel: false);

                                    // Split cart into two groups: shawarma/juices vs others
                                    final shawarmaCats = ['شاورما'];
                                    final shawarmaItems =
                                        value.cart.where((item) {
                                      final cat = (item is Map)
                                          ? (item['category'] ?? '')
                                          : (item.category ?? '');
                                      return shawarmaCats.contains(cat);
                                    }).toList();

                                    // cart for juices
                                    final juicesCats = ['عصائر'];
                                    final juicesItems =
                                        value.cart.where((item) {
                                      final cat = (item is Map)
                                          ? (item['category'] ?? '')
                                          : (item.category ?? '');
                                      return juicesCats.contains(cat);
                                    }).toList();

                                    //other cart items list
                                    final otherItems = value.cart.where((item) {
                                      final cat = (item is Map)
                                          ? (item['category'] ?? '')
                                          : (item.category ?? '');
                                      return !shawarmaCats.contains(cat) &&
                                          !juicesCats.contains(cat);
                                    }).toList();

                                    // Prepare and print separate payloads for each group
                                    try {
                                      if (shawarmaItems.isNotEmpty) {
                                        var shawData = Map.from(data);
                                        shawData['trans'] = shawarmaItems;
                                        shawData['amount'] =
                                            sumTotal(shawarmaItems);

                                        // printing here
                                        await printTwoCopies(
                                            'Save to PDF',
                                            billCounter,
                                            type,
                                            userVal.user,
                                            shawData,
                                            cashierLabel: 'كارت عميل');
                                      }

                                      if (juicesItems.isNotEmpty) {
                                        var juiceData = Map.from(data);
                                        juiceData['trans'] = juicesItems;
                                        juiceData['amount'] =
                                            sumTotal(juicesItems);

                                        await printTwoCopies(
                                            'Save to PDF',
                                            billCounter,
                                            type,
                                            userVal.user,
                                            juiceData,
                                            cashierLabel: 'كارت عميل');
                                      }

                                      if (otherItems.isNotEmpty) {
                                        var otherData = Map.from(data);
                                        otherData['trans'] = otherItems;
                                        otherData['amount'] =
                                            sumTotal(otherItems);

                                        await printTwoCopies(
                                            'Save to PDF',
                                            billCounter,
                                            type,
                                            userVal.user,
                                            otherData,
                                            cashierLabel: 'كارت عميل');
                                      }
                                    } catch (e) {
                                      // Common on web: cross-realm JS exceptions (Permission denied...)
                                      // Provide a user-friendly fallback instead of letting it crash.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'خطأ أثناء الطباعة: ${e.toString()}. حاول حفظ الفاتورة كـ PDF أو استخدم متصفحًا مختلفًا.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    //reset cart
                                    cartProvider.resetCart();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Center(
                                            child: Text(
                                          "الرجاء اضافة اصناف الى الفاتورة",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white),
                                        )),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.paypal,
                                  color: Colors.black,
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal),
                                label: Text(
                                  'دفع الفاتورة',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: fontSize(
                                          desktopCalc: width / 80, mobile: 16)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: 35),
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
