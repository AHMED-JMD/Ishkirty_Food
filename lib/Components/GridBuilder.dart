import 'package:ashkerty_food/Components/GridCard.dart';
import 'package:flutter/material.dart';

class GridViewBuilder extends StatefulWidget {
  final List data;
  final String flag;
  const GridViewBuilder({super.key, required this.data, required this.flag});

  @override
  State<GridViewBuilder> createState() => _GridViewBuilderState();
}

class _GridViewBuilderState extends State<GridViewBuilder> {
  @override
  Widget build(BuildContext context) {
    final List speices = List.from(widget.data);
    if (widget.flag == "sales") {
      speices.sort((a, b) => b['tot_sales'].compareTo(a['tot_sales']));
    }

    //layout builder for making the app responsive on diffrent screen sizes
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 2000) {
          return GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: speices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //amount of data you want on a row
                crossAxisCount: 9,
              ),
              itemBuilder: (context, index) =>
                  //call the card widget and set custom width and height !!default height best 200!!!
                  GridCart(
                    speices: speices[index],
                    widths: 280,
                    height: 270,
                    flag: widget.flag,
                  ));
        } else {
          if (constraints.maxWidth > 1600) {
            return GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: speices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //amount of data you want on a row
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) =>
                    //call the card widget and set custom width and height !!default height best 200!!!
                    GridCart(
                      speices: speices[index],
                      widths: 220,
                      height: 220,
                      flag: widget.flag,
                    ));
          } else {
            if (constraints.maxWidth > 1400) {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: speices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //amount of data you want on a row
                    crossAxisCount: 7,
                  ),
                  itemBuilder: (context, index) =>
                      //call the card widget and set custom width and height !!default height best 200!!!
                      GridCart(
                        speices: speices[index],
                        widths: 200,
                        height: 209,
                        flag: widget.flag,
                      ));
            } else {
              if (constraints.maxWidth > 1200) {
                //the row of data shown on the screen with gridView builder widget
                return GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: speices.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      //amount of data you want on a row
                      crossAxisCount: 6,
                    ),
                    itemBuilder: (context, index) =>
                        //call the card widget and set custom width and height !!default height best 200!!!
                        GridCart(
                            speices: speices[index],
                            widths: 245,
                            height: 204,
                            flag: widget.flag));
              } else {
                if (constraints.maxWidth > 1000) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: speices.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemBuilder: (context, index) => GridCart(
                          speices: speices[index],
                          widths: 350,
                          height: 230,
                          flag: widget.flag));
                } else {
                  if (constraints.maxWidth > 680) {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: speices.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          // childAspectRatio: 1.3
                        ),
                        itemBuilder: (context, index) => GridCart(
                            speices: speices[index],
                            widths: 200,
                            height: 250,
                            flag: widget.flag));
                  } else {
                    if (constraints.maxWidth > 480) {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: speices.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 0.7),
                          itemBuilder: (context, index) => GridCart(
                              speices: speices[index],
                              widths: 200,
                              height: 200,
                              flag: widget.flag));
                    } else {
                      if (constraints.maxWidth > 200) {
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: speices.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (context, index) => GridCart(
                                speices: speices[index],
                                widths: 250,
                                height: 200,
                                flag: widget.flag));
                      } else {
                        if (constraints.maxWidth > 400) {
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: speices.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) => GridCart(
                                  speices: speices[index],
                                  widths: 200,
                                  height: 200,
                                  flag: widget.flag));
                        } else {
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: speices.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) => GridCart(
                                  speices: speices[index],
                                  widths: 180,
                                  height: 300,
                                  flag: widget.flag));
                        }
                      }
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
