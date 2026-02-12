import 'package:ashkerty_food/static/current_location_badge.dart';
import 'package:flutter/material.dart';

class HomeDrawerbut extends StatelessWidget {
  const HomeDrawerbut({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CurrentLocationBadge(),
        Builder(
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
        ),
      ],
    );
  }
}
