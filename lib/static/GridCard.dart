import 'package:ashkerty_food/models/cart_model.dart';
import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_card/image_card.dart';

class GridCart extends StatefulWidget {
  final Map speices;
  final double widths;
  final double height;
  GridCart({
    super.key,
    required this.speices,
    required this.widths,
    required this.height,
  });

  @override
  State<GridCart> createState() => _GridCartState();
}

class _GridCartState extends State<GridCart> {
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, child) {
      var cartProvider = context.read<CartProvider>();

      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          child: TransparentImageCard(
            width: widget.widths,
            height: widget.height,
            imageProvider: NetworkImage(
                'http://localhost:3000/${widget.speices['ImgLink']}'),
            // tags: [ _tag('Product', () {}), ],
            title: Center(
              child: Text('${widget.speices['name']}  ${widget.speices['price']}-جنيه',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
            description: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: isAdded == false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              //new model ready for cart
                              Cart model = Cart(
                                  spices: widget.speices['name'],
                                  counter: 1,
                                  unit_price: widget.speices['price'],
                                  total_price: widget.speices['price']
                              );
                              //getting cart provider function
                              cartProvider.addToCart(model);
                              //setting the state
                              setState(() {
                                isAdded = true;
                              });
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.teal,
                                primary: Colors.white),
                            label: Text('اضف للسلة'),
                            icon: Icon(
                              Icons.add_box,
                              color: Color(0xffffffff),
                              size: 27,
                            )),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            //add amount
                            value.cart.map((item) =>{
                              if(item.spices == widget.speices['name']){
                                cartProvider.addAmount(item)
                              }
                            });
                          },
                          icon: Icon(
                            Icons.add_box,
                            color: Colors.teal,
                            size: 27,
                          ),
                          tooltip: 'إضافة',
                        ),
                        Text('yes',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                        IconButton(
                          onPressed: () {
                            //decrease amount
                            value.cart.map((item) =>{
                              if(item.spices == widget.speices['name']){
                                cartProvider.minusAmount(item)
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.teal,
                            size: 27,
                          ),
                          tooltip: 'نقصان',
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
