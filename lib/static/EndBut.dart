import 'package:flutter/material.dart';
class EndBut extends StatelessWidget {
  const EndBut({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return   IconButton(
          tooltip: 'Open bottom navigation menu',
          icon: const Icon(Icons.menu,
            size: 36,
            color: Color(0xff2a2626),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    );
  }
}
