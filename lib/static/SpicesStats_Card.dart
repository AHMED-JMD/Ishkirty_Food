import 'package:flutter/material.dart';

class SpiecesCard extends StatelessWidget {
  final String title;
  final int total;
  const SpiecesCard({super.key, required this.title, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.grey[200],
        border: Border.all(
          width: 1,
          color: Colors.grey
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$title", style: TextStyle(fontSize: 20),),
          Text("$total", style: TextStyle(fontSize: 35, color: Colors.teal, fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}
