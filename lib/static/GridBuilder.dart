import 'package:ashkerty_food/static/modal.dart';
import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:intl/intl.dart';
class GridViewBuilder extends StatelessWidget {
  final List data;
  GridViewBuilder({super.key, required this.data});
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
  //card Widget holding the image and width and height and data
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
            Text('السعر :${myFormat.format(speices.price)}جنيه ',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            ElevatedButton(
                onPressed: () {
                  Order_Modal(context, speices);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple
                ),
                child: Text('فاتورة'))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //layout builder for making the app responsive on diffrent screen sizes
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1200) {
          //the row of data shown on the screen with gridView builder widget
          return GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //amount of data you want on a row
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) =>
              //call the card widget and set custom height and width !!default height best 200!!!
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
