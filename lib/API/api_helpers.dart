import '../utils/businessLocation.dart';

Map<String, String> buildHeaders({Map<String, String>? extra}) {
  final headers = <String, String>{
    'Content-Type': 'application/json',
  };

  final location = AuthContext.businessLocation?.toString().trim();
  if (location != null && location.isNotEmpty) {
    headers['business_location'] = location;
  }

  if (extra != null) {
    headers.addAll(extra);
  }

  return headers;
}

Map<String, dynamic> attachBusinessLocation(dynamic data) {
  final location = AuthContext.businessLocation?.toString().trim();
  final map = <String, dynamic>{};

  if (data is Map) {
    map.addAll(Map<String, dynamic>.from(data));
  }

  if (location != null && location.isNotEmpty) {
    map.putIfAbsent('business_location', () => location);
  }

  return map;
}
