import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:intl/intl.dart';

import 'package:ashkerty_food/Components/Forms/CheckoutForm.dart';

class GridViewBuilder extends StatefulWidget {
  final List data;
  GridViewBuilder({super.key, required this.data});

  @override
  State<GridViewBuilder> createState() => _GridViewBuilderState();
}

class _GridViewBuilderState extends State<GridViewBuilder> {

  //card Widget holding the image and width and height and data
  Widget _card(BuildContext context, speices, double widths, double height) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        child: TransparentImageCard(
          width: widths,
          height: height,
          imageProvider: NetworkImage('http://localhost:3000/${speices['ImgLink']}'),
          // tags: [ _tag('Product', () {}), ],
          title: Center(
            child: Text('${speices['name']}',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          description: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: (){Checkout(context);},
                icon: const Icon(Icons.add_box,color: Color(0xffffffff),size: 27,),tooltip: 'إضافة',),
              Text('${speices['price']} ',
                  style: const TextStyle(color: Colors.white, fontSize: 18)),
              IconButton(onPressed: (){Checkout(context);}, icon: const Icon(Icons.remove_circle,color: Colors.white,size: 27,),tooltip: 'نقصان',),
            ],
          ),
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
              itemCount: widget.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //amount of data you want on a row
                crossAxisCount: 6,
              ),
              itemBuilder: (context, index) =>
              //call the card widget and set custom width and height !!default height best 200!!!
                  _card(context, widget.data[index], 245, 204));
        } else {
          if (constraints.maxWidth > 1000) {
            return GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: widget.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) =>
                    _card(context, widget.data[index], 350.0, 200));
          } else {
            if (constraints.maxWidth > 800) {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: widget.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) =>
                      _card(context, widget.data[index], 300.0, 200));
            } else {
              if (constraints.maxWidth > 600) {
                return GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: widget.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) =>
                        _card(context, widget.data[index], 200.0, 200));
              } else {
                if (constraints.maxWidth > 500) {
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: widget.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) =>
                          _card(context, widget.data[index], 250.0, 200));
                } else {
                  if (constraints.maxWidth > 400) {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: widget.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) =>
                            _card(context, widget.data[index], 200.0, 200));
                  } else {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: widget.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) =>
                            _card(context, widget.data[index], 180.0, 300));
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
