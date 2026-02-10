import 'local_storage.dart' as storage;

class AuthContext {
  static const String _businessLocationKey = 'business_location';
  static String? _businessLocation;

  static String? get businessLocation {
    _businessLocation ??= storage.getLocal(_businessLocationKey);
    return _businessLocation;
  }

  static set businessLocation(String? value) {
    _businessLocation = value;
    try {
      if (value == null) {
        storage.removeLocal(_businessLocationKey);
      } else {
        storage.setLocal(_businessLocationKey, value);
      }
    } catch (e) {}
  }
}
