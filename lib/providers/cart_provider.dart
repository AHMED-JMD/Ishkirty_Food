import 'package:ashkerty_food/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Cart> _cart = [];
  int _counter = 0;

  get cart => _cart;
  get counter => _counter;

  //counter logic---------
  void increment_counter(){
    _counter++;
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
    model.counter = model.counter + 1;
    model.total_price = model.unit_price * model.counter;

    notifyListeners();
  }

  void minusAmount (Cart model){
    //check and iterate and minus
    if(model.counter > 1){
      model.counter = model.counter - 1;
      model.total_price = model.unit_price * model.counter;
    }
    notifyListeners();
  }

  void addonsUpdate(Cart model ,addon, int amount){

    model.total_price = model.total_price + addon['price'] * amount;

    model.addons.add(amount.toString() + ' ' + addon['name']);
    notifyListeners();
  }

  void deletefromCart (Cart model){
    //remove from list
    _cart.remove(model);
    notifyListeners();
  }

  void resetCart () async {
    await Future.delayed(Duration(seconds: 2));
    _cart = [];
    notifyListeners();
  }

}