import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final Function(Map) searchDates;
  const MyDropdownButton({super.key, required this.searchDates});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String selectedValue = 'فواتير اليوم';
  DateTime start_date = DateTime.now();

  List<String> dropdownItems = [
    'فواتير اليوم',
    'فواتير الاسبوع',
    'فواتير الشهر',
  ];

  Map dates = {
    'فواتير الشهر': DateTime.now().subtract(const Duration(days: 30)),
    'فواتير الاسبوع': DateTime.now().subtract(const Duration(days: 7)),
    'فواتير اليوم': DateTime.now(),
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<String>(
        value: selectedValue,
        icon: const Icon(
          Icons.arrow_downward,
          color: Colors.teal,
        ),
        iconSize: 18,
        elevation: 16,
        style: const TextStyle(
            color: Colors.teal, fontFamily: 'Cairo', fontSize: 19),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (newValue) {
          setState(() {
            selectedValue = newValue!;
          });

          //call search dates
          Map datas = {};
          datas['end_date'] = start_date.toIso8601String();
          datas['start_date'] = dates[selectedValue].toIso8601String();

          widget.searchDates(datas);
        },
        items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
