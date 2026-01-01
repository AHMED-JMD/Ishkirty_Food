import 'package:ashkerty_food/static/GridCard.dart';
import 'package:flutter/material.dart';

class GridViewBuilder extends StatefulWidget {
  final List data;
  const GridViewBuilder({super.key, required this.data});

  @override
  State<GridViewBuilder> createState() => _GridViewBuilderState();
}

class _GridViewBuilderState extends State<GridViewBuilder> {
  @override
  Widget build(BuildContext context) {
    //layout builder for making the app responsive on diffrent screen sizes
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1400) {
          return GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: widget.data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //amount of data you want on a row
                crossAxisCount: 7,
              ),
              itemBuilder: (context, index) =>
                  //call the card widget and set custom width and height !!default height best 200!!!
                  GridCart(
                      speices: widget.data[index], widths: 245, height: 204));
        } else {
          if (constraints.maxWidth > 1200) {
            //the row of data shown on the screen with gridView builder widget
            return GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: widget.data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //amount of data you want on a row
                  crossAxisCount: 6,
                ),
                itemBuilder: (context, index) =>
                    //call the card widget and set custom width and height !!default height best 200!!!
                    GridCart(
                        speices: widget.data[index], widths: 245, height: 204));
          } else {
            if (constraints.maxWidth > 1000) {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: widget.data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (context, index) => GridCart(
                      speices: widget.data[index], widths: 350, height: 230));
            } else {
              if (constraints.maxWidth > 680) {
                return GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: widget.data.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      // childAspectRatio: 1.3
                    ),
                    itemBuilder: (context, index) => GridCart(
                        speices: widget.data[index], widths: 200, height: 250));
              } else {
                if (constraints.maxWidth > 480) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: widget.data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 0.7),
                      itemBuilder: (context, index) => GridCart(
                          speices: widget.data[index],
                          widths: 200,
                          height: 200));
                } else {
                  if (constraints.maxWidth > 200) {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: widget.data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) => GridCart(
                            speices: widget.data[index],
                            widths: 250,
                            height: 200));
                  } else {
                    if (constraints.maxWidth > 400) {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: widget.data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) => GridCart(
                              speices: widget.data[index],
                              widths: 200,
                              height: 200));
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: widget.data.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) => GridCart(
                              speices: widget.data[index],
                              widths: 180,
                              height: 300));
                    }
                  }
                }
              }
            }
          }
        }
      },
    );
  }
}
