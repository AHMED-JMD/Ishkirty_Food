import 'package:flutter/material.dart';

class HomeDrawerbut extends StatelessWidget {
  const HomeDrawerbut ({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            size: 35,
            color: Colors.black,
          ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        );
      },
    );
  }
}
