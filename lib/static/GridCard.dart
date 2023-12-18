import 'package:ashkerty_food/models/cart_model.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_card/image_card.dart';

class GridCart extends StatefulWidget {
  final Map speices;
  final double widths;
  final double height;
  GridCart({super.key, required this.speices, required this.widths, required this.height, });

  @override
  State<GridCart> createState() => _GridCartState(speices: speices, widths: widths, height: height);
}

class _GridCartState extends State<GridCart> {
  final speices;
  final double widths;
  final double height;
  _GridCartState({ required this.speices, required this.widths, required this.height, });

  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          child: TransparentImageCard(
            width: widths,
            height: height,
            imageProvider: NetworkImage('http://localhost:3000/${speices['ImgLink']}'),
            // tags: [ _tag('Product', () {}), ],
            title: Center(
              child: Text('${speices['name']}',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
            description: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: isAdded == false ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(onPressed: (){
                    //new model ready for cart
                    Cart model = Cart(spices: speices['name'], counter: 1, unit_price: speices['price'], total_price: speices['price']);
                    //getting cart provider function
                    var cartProvider = context.read<CartProvider>();
                    cartProvider.addToCart(model);
                    //setting the state
                    setState(() {
                      isAdded = true;
                    });
                  },
                      style: TextButton.styleFrom(backgroundColor: Colors.teal, primary: Colors.white),
                      label: Text('اضف للسلة'),
                      icon: Icon(Icons.add_box,color: Color(0xffffffff),size: 27,)),
                ],
              ): Center(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text("تمت الاضافة بنجاح "),
                    ),
                  )
              ),
            ),
          ),
        ),
      );
    });
  }
}
