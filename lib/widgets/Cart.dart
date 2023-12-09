import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/static/PaymentMethodSelector.dart';
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
         Container(
            width: 600,
            child: Card(
              color: Colors.grey[300],
              child: Column(
                children: [
                  ListTile(
                    title: Text("${item.spices}"),
                    subtitle: Text("السعر : ${item.unit_price}"),
                    trailing: IconButton(
                      onPressed: () {
                        //delete from cart provider
                        cartProvider.deletefromCart(item);
                      },
                      icon: Icon(Icons.delete, color: Colors.redAccent,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ListTile(
                    title: Text("الكمية"),
                    subtitle: Column(
                      children: [
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
                                style: const TextStyle(color: Colors.black, fontSize: 18)),
                            IconButton(
                              onPressed: (){
                                //decrease amount
                                cartProvider.minusAmount(item);
                              },
                              icon: const Icon(Icons.remove_circle,color: Colors.teal,size: 27,),tooltip: 'نقصان',),
                          ],
                        ),
                        SizedBox(height: 22,),
                        Text("السعر الكلي: ${item.unit_price * item.counter}", style: TextStyle(fontSize: 21, color: Colors.black),)
                      ],
                    ),
                  ),
                ],
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
      sum = sum + cart[i].unit_price;
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
            ListView(
              children:[
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("المبلغ الكلي: ${total}", textAlign: TextAlign.center,style: TextStyle(fontSize: 21),),
                          SizedBox(height: 20,),
                          Text('طريقة الدفع', textAlign: TextAlign.center,),
                          PaymentMethodSelector(),

                        ],
                      ),
                    ),
                    SizedBox(
                      width: 900,
                      height: 700,
                      child: ListView.builder(
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
                  ],
                ),

              ]
            ) :
            Center(child: Text('السلة فارغة اضف منتجات للسلة ..', style: TextStyle(fontSize: 19),),
              ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.print),
              backgroundColor: Colors.blueGrey,
              tooltip: 'طباعة الفاتورة',
            ),
          )
      );
    });
  }
}
