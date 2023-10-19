import 'package:flutter/material.dart';

class LeadingDrawerBtn extends StatelessWidget {
  const LeadingDrawerBtn ({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            size: 35,
            color: Colors.white,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        );
      },
    );
  }
}
