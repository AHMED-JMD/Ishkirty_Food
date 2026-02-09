import 'package:flutter/material.dart';
import '../utils/businessLocation.dart';
import '../utils/local_storage.dart' as storage;

class AuthProvider extends ChangeNotifier {
  Map _user = {};
  String _token = '';

  get user => _user;
  get token => _token;

  void Login(user, token) {
    _user = user;
    _token = token;
    AuthContext.businessLocation = user?['business_location']?.toString();
    // persist token to browser localStorage on web
    try {
      if (token != null) storage.setLocal('token', token);
    } catch (e) {}
    notifyListeners();
  }

  void Logout() {
    _user = {};
    _token = '';
    AuthContext.businessLocation = null;
    try {
      storage.removeLocal('token');
    } catch (e) {}
    notifyListeners();
  }
}
