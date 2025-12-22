import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  Map _user = {};
  String _token = '';

  get user => _user;
  get token => _token;

  void Login (user, token) {
    _user = user;
    _token = token;
    notifyListeners();
  }

  void Logout () {
    _user = {};
    _token = '';
    notifyListeners();
  }
}