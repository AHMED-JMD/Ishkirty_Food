import 'package:ashkerty_food/Components/buftake.dart';
import 'package:ashkerty_food/Components/juicies.dart';
import 'package:ashkerty_food/Components/meat.dart';
import 'package:ashkerty_food/Components/traditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SpiecesNav extends StatefulWidget {
  const SpiecesNav({super.key});

  @override
  State<SpiecesNav> createState() => _SpiecesNavState();
}

class _SpiecesNavState extends State<SpiecesNav> {

  List Pages = [
    {'widget': Column(
      children: [
        Traditional(),
        Meat(),
        BufTakes(),
        Juicies()
      ],
    ), 'name': 'الكل'},
    {'widget': Traditional(), 'name': 'تقليدي'},
    {'widget': Meat(), 'name': 'اللحوم'},
    {'widget': BufTakes(), 'name': 'البفتيك'},
    {'widget': Juicies(), 'name': 'العصائر'},
  ];

  Object? selectedPage = Column(
    children: [
      Traditional(),
      Meat(),
      BufTakes(),
      Juicies()
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 500,
          child: FormBuilderDropdown(
            name: 'spieces',
            decoration: InputDecoration(labelText: 'تصنيف'),
            onChanged: (val) {
               setState(() {
                 selectedPage = val;
               });
            },
            items: Pages
                .map((client) => DropdownMenuItem(
                value: client['widget'],
                child: Text('${client['name']}')
            )).toList(),
            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
          ),
        ),
        selectedPage as Widget
      ],
    );
  }
}
