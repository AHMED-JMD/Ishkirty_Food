import 'package:ashkerty_food/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _cart = [];

  get cart => _cart;

  void addToCart(Cart model) {

    //add to cart
    _cart.add(model);
  }

  void addAmount (Cart model){
    //check and iterate and add
    for(int i = 0; i< _cart.length; i++){
      if(_cart[i].spices == model.spices){
        _cart[i].counter = _cart[i].counter + 1;
      }
    }
  }

  void minusAmount (Cart model){
    //check and iterate and minus
    for(int i = 0; i< _cart.length; i++){
      if(_cart[i].spices == model.spices){
        _cart[i].counter = _cart[i].counter - 1;
      }
    }
  }

  void deletefromCart (Cart model){
    //remove from list
    _cart.remove(model);
  }
}