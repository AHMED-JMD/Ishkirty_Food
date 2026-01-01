import 'package:flutter/material.dart';

class CheckTime extends StatelessWidget {
  const CheckTime({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    DateTime sixPM = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 18, 0, 0);

    bool isAfterSixPM = currentTime.isAfter(sixPM);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.teal.shade700,
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          isAfterSixPM ? 'الوردية المسائية' : 'الوردية الصباحية',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
