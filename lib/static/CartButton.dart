import 'package:ashkerty_food/providers/cart_provider.dart';
import 'package:ashkerty_food/widgets/Cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, child) {
      return Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyCart()));
            },
            child: Icon(Icons.shopping_cart),
            backgroundColor: Colors.teal,
            tooltip: 'السلة',
          ),
          value.cart.length > 0
              ? Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      value.cart.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      );
    });
  }
}
