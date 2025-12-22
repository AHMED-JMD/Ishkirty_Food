import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/Components/juicies.dart';
import 'package:ashkerty_food/Components/meat.dart';
import 'package:ashkerty_food/Components/traditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ashkerty_food/Components/Toppings.dart';

class SpiecesNav extends StatefulWidget {
  const SpiecesNav({super.key});

  @override
  State<SpiecesNav> createState() => _SpiecesNavState();
}

class _SpiecesNavState extends State<SpiecesNav> {
  bool isLoading = false;

  //--get speices
  Future getSpieces(data) async {
    setState(() {
      isLoading = true;
    });
    //call the api
    final response = await APISpieces.getByType(data);

    if (response != false) {
      return response;
    } else {
      return [];
    }
  }

  //list of pages
  late List Pages = [
    {
      'widget': Column(
        children: [
          Traditional(),
          Meat(),
          Toppings(),
          Juicies(),
        ],
      ),
      'name': 'الكل'
    },
    {'widget': Traditional(), 'name': 'تقليدي'},
    {'widget': Meat(), 'name': 'اللحوم'},
    {'widget': Toppings(), 'name': 'إضافات'},
    {'widget': Juicies(), 'name': 'العصائر'},
  ];
  late Object? selectedPage = Column(
    children: [
      Traditional(),
      Meat(),
      Toppings(),
      Juicies(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 500,
          child: FormBuilderDropdown(
            name: 'spieces',
            decoration: const InputDecoration(labelText: 'تصنيف'),
            onChanged: (val) {
              setState(() {
                selectedPage = val;
                //call data again
              });
            },
            items: Pages.map((page) => DropdownMenuItem(
                value: page['widget'],
                child: Text('${page['name']}'))).toList(),
            validator: FormBuilderValidators.required(
                errorText: "الرجاء ادخال جميع الجقول"),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        selectedPage as Widget
      ],
    );
  }
}
