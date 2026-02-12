import 'package:ashkerty_food/utils/businessLocation.dart';
import 'package:flutter/material.dart';

class CurrentLocationBadge extends StatelessWidget {
  final bool compact;

  const CurrentLocationBadge({super.key, this.compact = true});

  @override
  Widget build(BuildContext context) {
    final raw = AuthContext.businessLocation?.toString().trim();
    final location = (raw == null || raw.isEmpty) ? 'غير محدد' : raw;
    final textStyle = TextStyle(
      fontSize: compact ? 14 : 16,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );

    return Tooltip(
      message: 'الموقع الحالي: $location',
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 10,
          vertical: compact ? 6 : 8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 12,
          vertical: compact ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.teal.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.teal.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.black54),
            const SizedBox(width: 4),
            Text('الموقع: $location', style: textStyle),
          ],
        ),
      ),
    );
  }
}
