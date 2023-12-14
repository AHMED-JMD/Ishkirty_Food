import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/static/PaymentMethodSelector.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  //custom cart widget
  Widget _cart (BuildContext context, item, cartProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Padding(
           padding: const EdgeInsets.only(bottom: 8.0),
           child: Container(
              width: 350,
              child: Card(
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "${item.spices} : ${item.unit_price}",
                          style: TextStyle(fontSize: 26, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                        ),
                      ),
                        IconButton(
                          onPressed: () {
                            //delete from cart provider
                            cartProvider.deletefromCart(item);
                          },
                          icon: Icon(Icons.delete, color: Colors.redAccent,),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text(
                        "الكمية",
                      style: TextStyle(fontSize: 22,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: (){
                            //add amount
                            cartProvider.addAmount(item);
                            },
                          icon: Icon(Icons.add_box,color: Colors.teal ,size: 27,),tooltip: 'إضافة',),
                        Text('${item.counter}',
                            style: const TextStyle(color: Colors.black, fontSize: 18)
                        ),
                        IconButton(
                          onPressed: (){
                            //decrease amount
                            cartProvider.minusAmount(item);
                            },
                          icon: const Icon(Icons.remove_circle,color: Colors.teal,size: 27,),tooltip: 'نقصان',),
                      ],
                    ),
                          SizedBox(height: 15,),
                          Text(
                            "السعر الكلي: ${item.total_price}",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 21, color: Colors.black),
                          )
                  ],
                ),
              ),
            ),
         ),
      ],
    );
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
    return Consumer<CartProvider>(builder: (context, value, child) {
      var total = sumTotal(value.cart);

      return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              centerTitle: true,
              title: Text('سلة الفواتير'),
            ),
            body: value.cart.length != 0 ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        width: 800,
                        height: 700,
                        color: Colors.grey[100],
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2
                          ),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: value.cart.length,
                          itemBuilder: (context, index) {
                            //current item
                            var item = value.cart[index];
                            var cartProvider = context.read<CartProvider>();
                            //call cart widget and iterate
                            return _cart(context, item, cartProvider);
                          },
                        ),
                      ),
                    ),
                Container(
                  color: Colors.blueGrey[300],
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80.0, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Text('اختر طريقة الدفع', textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 19,
                          color: Colors.white
                          ),
                        ),
                        SizedBox(height: 15,),
                        PaymentMethodSelector(),
                        SizedBox(height: 15,),

                        Center(
                          child: FormBuilderRadioGroup(
                            name: 'shift',
                            decoration: InputDecoration(
                                labelText: 'اختر الوردية', contentPadding: EdgeInsets.all(10.0)),
                            options: [
                              FormBuilderFieldOption(value: 'صباحية'),
                              FormBuilderFieldOption(value: 'مسائية'),
                            ],
                          ),
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                                onPressed: (){},
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
                        SizedBox(height: 40),
                        Text('عدد الاصناف = ${value.cart.length}', textAlign: TextAlign.center, style: TextStyle(
                            fontSize: 19,
                            color: Colors.white
                        ),
                        ),
                        Text("المبلغ الكلي: ${total}", textAlign: TextAlign.center,style: TextStyle(
                            fontSize: 30,
                            color: Colors.white
                        ),
                        ),


                      ],
                    ),
                  ),
                ),

              ]
            ) :
            Center(child: Text('السلة فارغة اضف منتجات للسلة ..', style: TextStyle(fontSize: 19),),
              ),
          )
      );
    });
  }
}
