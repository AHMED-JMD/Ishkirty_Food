class StoreAssociation {
  String storeId;
  String spiceId;
  String storeName;
  int quantityNeeded;
  bool isKilo;

  StoreAssociation({
    required this.storeId,
    required this.spiceId,
    required this.storeName,
    required this.quantityNeeded,
    required this.isKilo,
  });

  factory StoreAssociation.fromJson(Map<String, dynamic> json) =>
      StoreAssociation(
        storeId: json['store_id'].toString(),
        spiceId: json['spice_id'].toString(),
        storeName: json['store_name'] ?? '',
        quantityNeeded: (json['quantity_needed'] is num)
            ? (json['quantity_needed'] as num).toInt()
            : int.tryParse(json['quantity_needed']?.toString() ?? '') ?? 0,
        isKilo: json['isKilo'],
      );

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'spice_id': spiceId,
        'store_name': storeName,
        'quantity_needed': quantityNeeded,
        'is_kilo': isKilo,
      };
}
