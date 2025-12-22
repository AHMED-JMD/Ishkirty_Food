import 'package:flutter/material.dart';

class CheckTime extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    DateTime currentTime = DateTime.now();
    DateTime sixPM = DateTime(currentTime.year, currentTime.month, currentTime.day, 18, 0, 0);

    bool isAfterSixPM = currentTime.isAfter(sixPM);

    return Center(
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.teal.shade700,
            borderRadius: BorderRadius.circular(4)
          ),
          child: Text(
            isAfterSixPM ? 'الوردية المسائية' : 'الوردية الصباحية',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      );
  }
}