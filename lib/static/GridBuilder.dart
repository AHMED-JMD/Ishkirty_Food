import 'package:ashkerty_food/static/modal.dart';
import 'package:flutter/material.dart';
import 'packa''ge:image_card/image_card.dart';
import 'package:intl/intl.dart';

import 'PaymentMethodSelector.dart';
class GridViewBuilder extends StatefulWidget {
  final List data;
  GridViewBuilder({super.key, required this.data});

  @override
  State<GridViewBuilder> createState() => _GridViewBuilderState();
}

class _GridViewBuilderState extends State<GridViewBuilder> {
  NumberFormat myFormat = NumberFormat.decimalPattern('en_us');

  //card Widget holding the image and width and height and data
  Widget _card(BuildContext context, speices, double widths, double height) {
    return Container(
      child: TransparentImageCard(
        width: widths,
        height: height,
        imageProvider: AssetImage('assets/images/${speices.imageLink}'),
        // tags: [ _tag('Product', () {}), ],
        title: Center(
          child: Text('${speices.name}',
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
        description: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10,),
            IconButton(onPressed: (){
                Container(width:350,height: 70, decoration: BoxDecoration(
                color: const Color(0xffffffff),
                border: Border.all(
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,30,12),
                  child:   PaymentMethodSelector(),
                ),
              );
            }, icon: const Icon(Icons.add_box,color: Color(0xffffffff),size: 27,),tooltip: 'إضافة',),
            const SizedBox(width: 40,),
            Text('${myFormat.format(speices.price)} ',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(width: 40,),
            IconButton(onPressed: (){}, icon: const Icon(Icons.remove_circle,color: Colors.white,size: 27,),tooltip: 'نقصان',),
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
              itemCount: widget.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //amount of data you want on a row
                crossAxisCount: 6,
              ),
              itemBuilder: (context, index) =>
              //call the card widget and set custom height and width !!default height best 200!!!
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
