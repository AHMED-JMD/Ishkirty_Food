import 'package:ashkerty_food/static/modal.dart';
import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';

class GridViewBuilder extends StatelessWidget {
  final List data;
  GridViewBuilder({super.key, required this.data});

  //card Widget
  Widget _card(BuildContext context, speices, double widths, double height) {
    return Container(
      child: TransparentImageCard(
        width: widths,
        height: height,
        imageProvider: AssetImage('assets/images/${speices.imageLink}'),
        // tags: [ _tag('Product', () {}), ],
        title: Text('${speices.name}',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        description: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('السعر :${speices.price}جنيه ',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            ElevatedButton(
                onPressed: () {
                  Order_Modal(context, speices);
                },
                child: Text('فاتورة'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1200) {
          return GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) =>
                  _card(context, data[index], 300.0, 200));
        } else {
          if (constraints.maxWidth > 1000) {
            return GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) =>
                    _card(context, data[index], 350.0, 200));
          } else {
            if (constraints.maxWidth > 800) {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) =>
                      _card(context, data[index], 300.0, 200));
            } else {
              if (constraints.maxWidth > 600) {
                return GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) =>
                        _card(context, data[index], 200.0, 200));
              } else {
                if (constraints.maxWidth > 500) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) =>
                          _card(context, data[index], 250.0, 200));
                } else {
                  if (constraints.maxWidth > 400) {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) =>
                            _card(context, data[index], 200.0, 200));
                  } else {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) =>
                            _card(context, data[index], 180.0, 300));
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
