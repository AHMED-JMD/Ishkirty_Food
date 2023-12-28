import 'package:ashkerty_food/static/GridBuilder.dart';
import 'package:flutter/material.dart';
import 'package:ashkerty_food/API/Spieces.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Toppings extends StatefulWidget {
  @override
  State<Toppings> createState() => _ToppingsState();
}

class _ToppingsState extends State<Toppings> {
  List data = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    final response = await APISpieces.getByType({'category': 'اضافات'});

    if (response != false) {
      setState(() {
        isLoading = false;
        data = response;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'إضافات',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? SpinKitThreeBounce(
                    color: Colors.grey,
                    size: 30,
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GridViewBuilder(
                      data: data,
                    ),
                  )
          ],
        ));
  }
}
