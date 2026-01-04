import 'package:ashkerty_food/static/MenuCard.dart';
import 'package:ashkerty_food/static/SalesCard2.dart';
import 'package:flutter/material.dart';

class GridCart extends StatefulWidget {
  final Map speices;
  final double widths;
  final double height;
  final String flag;
  const GridCart({
    super.key,
    required this.speices,
    required this.widths,
    required this.height,
    required this.flag,
  });

  @override
  State<GridCart> createState() => _GridCartState();
}

class _GridCartState extends State<GridCart> {
  @override
  Widget build(BuildContext context) {
    //this to check if it SALES page or MAIN page
    //to get the use of the GridBuilder Code
    if (widget.flag == "sales") {
      return Salescard2(
          speices: widget.speices,
          widths: widget.widths,
          height: widget.height);
    } else {
      return Menucard(
          speices: widget.speices,
          widths: widget.widths,
          height: widget.height);
    }
  }
}
