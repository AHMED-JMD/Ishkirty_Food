import 'dart:convert';
import 'local_storage.dart' as storage;

const String _storeNamesKey = 'required_purchase_store_names';
const List<String> _defaultStoreNames = ['سيخ كفتة', 'سيخ اقاشي'];

List<String> getRequiredPurchaseStoreNames() {
  final raw = storage.getLocal(_storeNamesKey);
  if (raw is String && raw.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        final names = decoded
            .whereType<String>()
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        if (names.isNotEmpty) {
          return names;
        }
      }
    } catch (_) {
      // ignore parsing errors
    }
  }

  try {
    storage.setLocal(_storeNamesKey, jsonEncode(_defaultStoreNames));
  } catch (_) {
    // ignore storage errors
  }
  return List<String>.from(_defaultStoreNames);
}

void setRequiredPurchaseStoreNames(List<String> names) {
  final cleaned =
      names.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  try {
    storage.setLocal(_storeNamesKey, jsonEncode(cleaned));
  } catch (_) {
    // ignore storage errors
  }
}

bool purchasesContainRequiredStores(dynamic purchases, List<String> required) {
  if (purchases is! List) return false;
  if (purchases.isEmpty) return false;

  final requiredSet =
      required.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet();
  if (requiredSet.isEmpty) return true;

  final found = <String>{};
  for (final item in purchases) {
    if (item is Map) {
      final store = item['Store'] ?? item['store'];
      final storeName = store is Map ? store['name'] : null;
      if (storeName is String && requiredSet.contains(storeName)) {
        found.add(storeName);
      }
    }
  }
  return found.containsAll(requiredSet);
}
