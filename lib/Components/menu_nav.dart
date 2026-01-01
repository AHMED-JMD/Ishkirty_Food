import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/Components/menu.dart';
import 'package:ashkerty_food/Components/menu_categ.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class Menu_Nav extends StatefulWidget {
  const Menu_Nav({super.key});

  @override
  State<Menu_Nav> createState() => _Menu_NavState();
}

class _Menu_NavState extends State<Menu_Nav> {
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

  late Object? selectedPage = const Column(
    children: [
      MenuCategory(
        category: 'تقليدي',
      ),
      MenuCategory(
        category: 'لحوم',
      ),
      MenuCategory(
        category: 'اضافات',
      ),
      MenuCategory(
        category: 'عصائر',
      ),
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
            //Pages from menu file--
            items: menuPages
                .map((page) => DropdownMenuItem(
                    value: page['widget'], child: Text('${page['name']}')))
                .toList(),
            validator: FormBuilderValidators.required(
                errorText: "الرجاء ادخال جميع الحقول"),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        selectedPage as Widget
      ],
    );
  }
}
