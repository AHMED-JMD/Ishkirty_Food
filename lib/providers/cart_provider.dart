import 'package:ashkerty_food/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _cart = [];
  int _counter = 0;

  get cart => _cart;
  get counter => _counter;

  //counter logic---------
  void increment_counter(){
    if(_counter < 100){
      _counter++;
    }else if(counter == 100){
      _counter = 1;
      notifyListeners();
    }
    notifyListeners();
  }


  //cart logic------------------
  void addToCart(Cart model) {
    //add to cart
    _cart.add(model);
    notifyListeners();
  }

  void addAmount (Cart model){
    //check and iterate and add
    for(int i = 0; i< _cart.length; i++){
      if(_cart[i].spices == model.spices){
        _cart[i].counter = _cart[i].counter + 1;
        _cart[i].total_price = _cart[i].unit_price * _cart[i].counter;
      }
    }
    notifyListeners();
  }

  void minusAmount (Cart model){
    //check and iterate and minus
    for(int i = 0; i< _cart.length; i++){
      if(_cart[i].spices == model.spices){
        _cart[i].counter = _cart[i].counter - 1;
        _cart[i].total_price = _cart[i].unit_price * _cart[i].counter;
      }
    }
    notifyListeners();
  }

  void deletefromCart (Cart model){
    //remove from list
    _cart.remove(model);
    notifyListeners();
  }

}