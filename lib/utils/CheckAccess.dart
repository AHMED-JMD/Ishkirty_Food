import 'dart:convert';

import 'package:ashkerty_food/API/Daily.dart';
import 'package:ashkerty_food/providers/Auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> checkDailyAccess(BuildContext context) async {
  try {
    //check daily is created ---------------------------------------------
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?['id']?.toString();
    final role = authProvider.user?['role']?.toString();
    if (role != null && role.toLowerCase().contains('admin')) {
      // Admin has access to everything
      return;
    }
    if (userId != null && userId.isNotEmpty) {
      final dailyRes = await APIDaily.getOne({
        'date': DateTime.now().toIso8601String(),
        'admin_id': userId,
      });
      // if (!mounted) return;
      if (dailyRes.statusCode == 200) {
        final body = jsonDecode(dailyRes.body);
        final isCreated = body is Map && body['isCreated'] == true;
        if (isCreated) {
          Navigator.pushReplacementNamed(context, '/newDaily');
          return;
        }
      }
    }
  } catch (e) {
    // Handle error
  }
}
