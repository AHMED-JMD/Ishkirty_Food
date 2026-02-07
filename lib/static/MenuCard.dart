import 'package:ashkerty_food/models/cart_model.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/static/formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Menucard extends StatefulWidget {
  final Map speices;
  final double widths;
  final double height;
  const Menucard(
      {super.key,
      required this.speices,
      required this.widths,
      required this.height});

  @override
  State<Menucard> createState() => _MenucardState();
}

class _MenucardState extends State<Menucard> {
  bool isAdded = false;
  int amount = 1;
  late Cart model;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  //function to specify addons to spieces
  addonsModal(BuildContext context, List<Cart> cart, Map spice, cartProvider) {
    //remove addons from addons modal
    List<Cart> modCart =
        cart.where((element) => element.category != 'اضافات').toList();

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: SimpleDialog(
                title: Text(
                  ' اضافة ${widget.speices['name']}',
                  textAlign: TextAlign.center,
                ),
                children: [
                  FormBuilder(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FormBuilderDropdown(
                            name: 'model',
                            decoration: const InputDecoration(
                                labelText: 'اختر الصنف من السلة (اختياري)',
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  size: 20,
                                  color: Colors.teal,
                                )),
                            items: modCart
                                .map((item) => DropdownMenuItem(
                                    value: item, child: Text(item.spices)))
                                .toList(),
                          ),
                          FormBuilderTextField(
                            name: 'amount',
                            initialValue: '1',
                            decoration: const InputDecoration(
                              labelText: 'الكمية',
                              icon: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.teal,
                              ),
                            ),
                            validator: FormBuilderValidators.required(
                                errorText: 'الرجاء ادخال قيمة '),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Center(
                      child: SizedBox(
                        height: 40,
                        width: 100,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.saveAndValidate()) {
                                // create addon model
                                model = Cart(
                                    spices: spice['name'],
                                    counter: 1,
                                    category: spice['category'],
                                    addons: [],
                                    unit_price: spice['price'],
                                    total_price: spice['price']);

                                final selectedModel =
                                    _formKey.currentState!.value['model'];
                                int amount = int.parse(
                                    _formKey.currentState!.value['amount']);

                                setState(() {
                                  isAdded = true;
                                });
                                Navigator.of(context).pop();
                                // always add the addon item to the cart
                                cartProvider.addToCart(model);
                                // if a model from the cart was selected, update it with the addon
                                if (selectedModel != null) {
                                  cartProvider.addonsUpdate(
                                      selectedModel, model, amount);
                                }
                              }
                            },
                            child: const Text(
                              'حفظ',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, child) {
      var cartProvider = context.read<CartProvider>();

      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      final isPhone = width < 600;

      double fontSize({required double desktopCalc, required double mobile}) {
        return isPhone ? mobile : desktopCalc;
      }

      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: SizedBox(
          width: widget.widths,
          height: widget.height,
          child: InkWell(
            onTap: () {},
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: Colors.grey.shade300),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                '${widget.speices['name']} ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize(
                                      desktopCalc: width / 90, mobile: 13),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            if (isAdded)
                              Container(
                                color: Colors.white.withOpacity(0.7),
                                child: SizedBox(
                                  child: IconButton(
                                    onPressed: () {
                                      cartProvider.deletefromCart(model);
                                      setState(() {
                                        isAdded = false;
                                      });
                                    },
                                    tooltip: 'حذف',
                                    icon: const Icon(
                                      size: 17,
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        Text("جنيه ${numberFormatter(widget.speices['price'])}",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize:
                                  fontSize(desktopCalc: width / 90, mobile: 14),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: isAdded == false
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        if (widget.speices['category'] ==
                                            'اضافات') {
                                          addonsModal(context, value.cart,
                                              widget.speices, cartProvider);
                                        } else {
                                          model = Cart(
                                              spices: widget.speices['name'],
                                              counter: 1,
                                              category:
                                                  widget.speices['category'],
                                              addons: [],
                                              unit_price:
                                                  widget.speices['price'],
                                              total_price:
                                                  widget.speices['price']);
                                          cartProvider.addToCart(model);
                                          setState(() {
                                            isAdded = true;
                                          });
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        minimumSize: const Size(100, 50),
                                      ),
                                      child: const Text(
                                        'اضف للسلة',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          isPhone
                                              ? IconButton(
                                                  onPressed: () {
                                                    for (int i = 0;
                                                        i < value.cart.length;
                                                        i++) {
                                                      if (widget.speices[
                                                              'name'] ==
                                                          value
                                                              .cart[i].spices) {
                                                        cartProvider.addAmount(
                                                            value.cart[i]);
                                                        setState(() {
                                                          amount = value
                                                              .cart[i].counter;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.add_box,
                                                    color: Colors.black,
                                                    size: fontSize(
                                                        desktopCalc: 27,
                                                        mobile: 15),
                                                  ),
                                                  tooltip: 'إضافة',
                                                )
                                              : Container(
                                                  color: Colors.white,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      for (int i = 0;
                                                          i < value.cart.length;
                                                          i++) {
                                                        if (widget.speices[
                                                                'name'] ==
                                                            value.cart[i]
                                                                .spices) {
                                                          cartProvider
                                                              .addAmount(value
                                                                  .cart[i]);
                                                          setState(() {
                                                            amount = value
                                                                .cart[i]
                                                                .counter;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.add_box,
                                                      color: Colors.black,
                                                      size: fontSize(
                                                          desktopCalc: 27,
                                                          mobile: 15),
                                                    ),
                                                    tooltip: 'إضافة',
                                                  ),
                                                ),
                                          // Tappable amount: opens number-grid (1..10)
                                          InkWell(
                                            onTap: () async {
                                              final selected = await showDialog<
                                                      int>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext dialogCtx) {
                                                    return Directionality(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      child: AlertDialog(
                                                        title: const Center(
                                                          child: Text(
                                                              'اختر الكمية'),
                                                        ),
                                                        content: SizedBox(
                                                          width: double
                                                              .minPositive,
                                                          child: GridView.count(
                                                            shrinkWrap: true,
                                                            crossAxisCount: 3,
                                                            mainAxisSpacing: 8,
                                                            crossAxisSpacing: 8,
                                                            children:
                                                                List.generate(
                                                                    10, (i) {
                                                              int val = i + 1;
                                                              return ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey
                                                                          .shade300,
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          dialogCtx)
                                                                      .pop(val);
                                                                },
                                                                child: Text(
                                                                  '$val',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: fontSize(
                                                                          desktopCalc:
                                                                              17,
                                                                          mobile:
                                                                              16),
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });

                                              if (selected != null) {
                                                for (int i = 0;
                                                    i < value.cart.length;
                                                    i++) {
                                                  if (widget.speices['name'] ==
                                                      value.cart[i].spices) {
                                                    cartProvider.setAmount(
                                                        value.cart[i],
                                                        selected);
                                                    setState(() {
                                                      amount =
                                                          value.cart[i].counter;
                                                    });
                                                    break;
                                                  }
                                                }
                                              }
                                            },
                                            child: isPhone
                                                ? Text('$amount',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: fontSize(
                                                            desktopCalc: 16,
                                                            mobile: 12)))
                                                : Container(
                                                    color: Colors.white,
                                                    padding: EdgeInsets.all(
                                                        value.cart.length > 2
                                                            ? 5.0
                                                            : 10.0),
                                                    child: Text('$amount',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: fontSize(
                                                                desktopCalc: 16,
                                                                mobile: 12))),
                                                  ),
                                          ),
                                          isPhone
                                              ? IconButton(
                                                  onPressed: () {
                                                    for (int i = 0;
                                                        i < value.cart.length;
                                                        i++) {
                                                      if (widget.speices[
                                                              'name'] ==
                                                          value
                                                              .cart[i].spices) {
                                                        cartProvider
                                                            .minusAmount(
                                                                value.cart[i]);
                                                        setState(() {
                                                          amount = value
                                                              .cart[i].counter;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.black,
                                                    size: fontSize(
                                                        desktopCalc: 27,
                                                        mobile: 15),
                                                  ),
                                                  tooltip: 'نقصان',
                                                )
                                              : Container(
                                                  color: Colors.white,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      for (int i = 0;
                                                          i < value.cart.length;
                                                          i++) {
                                                        if (widget.speices[
                                                                'name'] ==
                                                            value.cart[i]
                                                                .spices) {
                                                          cartProvider
                                                              .minusAmount(value
                                                                  .cart[i]);
                                                          setState(() {
                                                            amount = value
                                                                .cart[i]
                                                                .counter;
                                                          });
                                                        }
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.black,
                                                      size: fontSize(
                                                          desktopCalc: 27,
                                                          mobile: 15),
                                                    ),
                                                    tooltip: 'نقصان',
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
