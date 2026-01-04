import 'package:ashkerty_food/Components/GridBuilder.dart';
import 'package:flutter/material.dart';
import 'package:ashkerty_food/API/Spieces.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MenuCategory extends StatefulWidget {
  final String category;

  const MenuCategory({super.key, required this.category});

  @override
  State<MenuCategory> createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> {
  List data = [];
  bool isLoading = false;

  @override
  void initState() {
    getData(widget.category);
    super.initState();
  }

  Future getData(String category) async {
    setState(() {
      isLoading = true;
    });

    final response = await APISpieces.getByType({'category': category});

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
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 28.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.category,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            isLoading
                ? const SpinKitThreeBounce(
                    color: Colors.grey,
                    size: 30,
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GridViewBuilder(
                      data: data,
                      flag: "menu",
                    ),
                  )
          ],
        ));
  }
}
