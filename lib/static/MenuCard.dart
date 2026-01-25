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
  addonsModal(BuildContext context, List cart, cartProvider) {
    //remove addons from addons modal
    cart.removeWhere((element) => element.category == 'اضافات');

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
                                labelText: 'اختر الصنف من السلة',
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  size: 20,
                                  color: Colors.teal,
                                )),
                            items: cart
                                .map((item) => DropdownMenuItem(
                                    value: item, child: Text(item.spices)))
                                .toList(),
                            validator: FormBuilderValidators.required(
                                errorText: 'الرجاء ادخال قيمة '),
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
                                //modify cart
                                Cart model =
                                    _formKey.currentState!.value['model'];
                                int amount = int.parse(
                                    _formKey.currentState!.value['amount']);

                                //update cart item
                                cartProvider.addonsUpdate(
                                    model, widget.speices, amount);
                                Navigator.of(context).pop();
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

      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: SizedBox(
          child: SizedBox(
            width: widget.widths,
            height: widget.height,
            child: InkWell(
              onTap: () {
                //check if it is addons
                if (widget.speices['category'] == 'اضافات') {
                  addonsModal(context, value.cart, cartProvider);
                } else {
                  //new model ready for cart
                  model = Cart(
                      spices: widget.speices['name'],
                      counter: 1,
                      category: widget.speices['category'],
                      addons: [],
                      unit_price: widget.speices['price'],
                      total_price: widget.speices['price']);
                  //getting cart provider function
                  cartProvider.addToCart(model);
                  //setting the state
                  setState(() {
                    isAdded = true;
                  });
                }
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                        'http://localhost:3000/${widget.speices['ImgLink']}',
                        fit: BoxFit.cover),
                    Container(color: Colors.black.withOpacity(0.35)),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 100,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              if (isAdded)
                                SizedBox(
                                  width: 20,
                                  child: IconButton(
                                    onPressed: () {
                                      //delete from cart provider
                                      cartProvider.deletefromCart(model);
                                      //setting the state
                                      setState(() {
                                        isAdded = false;
                                      });
                                    },
                                    tooltip: 'حذف',
                                    icon: const Icon(
                                      size: 25,
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 100,
                          ),
                          Text(
                              "جنيه ${numberFormatter(widget.speices['price'])}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width / 100,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 1.0),
                            child: isAdded == false
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          //check if it is addons
                                          if (widget.speices['category'] ==
                                              'اضافات') {
                                            addonsModal(context, value.cart,
                                                cartProvider);
                                          } else {
                                            //new model ready for cart
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
                                            //getting cart provider function
                                            cartProvider.addToCart(model);
                                            //setting the state
                                            setState(() {
                                              isAdded = true;
                                            });
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          minimumSize: const Size(100, 35),
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
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                //add amount
                                                for (int i = 0;
                                                    i < value.cart.length;
                                                    i++) {
                                                  if (widget.speices['name'] ==
                                                      value.cart[i].spices) {
                                                    cartProvider.addAmount(
                                                        value.cart[i]);
                                                    setState(() {
                                                      amount =
                                                          value.cart[i].counter;
                                                    });
                                                  }
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.add_box,
                                                color: Colors.white,
                                                size: 27,
                                              ),
                                              tooltip: 'إضافة',
                                            ),
                                            Text('$amount',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                            IconButton(
                                              onPressed: () {
                                                //decrease amount
                                                for (int i = 0;
                                                    i < value.cart.length;
                                                    i++) {
                                                  if (widget.speices['name'] ==
                                                      value.cart[i].spices) {
                                                    cartProvider.minusAmount(
                                                        value.cart[i]);
                                                    setState(() {
                                                      amount =
                                                          value.cart[i].counter;
                                                    });
                                                  }
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.white,
                                                size: 27,
                                              ),
                                              tooltip: 'نقصان',
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
        ),
      );
    });
  }
}
