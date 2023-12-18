import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/Components/Forms/CartForm.dart';
import 'package:ashkerty_food/widgets/Home.dart';
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
                          style: TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, child) {
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
                CartForm(),
              ]
            ) :
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyHomePage())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[200]
                      ) ,
                      label: Text("Go", style: TextStyle(
                        color: Colors.teal, fontSize: 23,
                      ),),
                      icon: Icon(Icons.shopping_cart_checkout, color: Colors.teal, size: 30,),
                  ),
                  SizedBox(width: 20,),
                  Text('سلة الفواتير فارغة قم باضافة اصناف ', style: TextStyle(fontSize: 24),),
                ],
              ),
              ),
          )
      );
    });
  }
}
