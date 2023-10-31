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
  List juices = [];
  List meat = [];
  List traditional = [];
  List toppings = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //juices
    getSpieces({'category': 'عصائر'}, 'juices');
    //meat
    getSpieces({'category': 'لحوم'}, 'meat');
    //toppings
    getSpieces({'category': 'اضافات'}, 'toppings');
    //traditional
    getSpieces({'category': 'تقليدي'}, 'traditional');
  }

  //--add client
  Future getSpieces(data, String name) async {
    setState(() {
      isLoading = true;
    });
    //call the api
    final response = await APISpieces.getByType(data);

    if(response != false){
      switch(name){
        case 'juices' :
          setState(() {
            juices = response;
          });
          break;
        case 'meat' :
          setState(() {
            meat = response;
          });
          break;
        case 'toppings' :
          setState(() {
            toppings = response;
          });
          break;
        case 'traditional' :
          setState(() {
            traditional = response;
          });
          break;
      }
    }

  }

  //list of pages
  late List Pages = [
    {'widget':  Column(
      children: [
        Traditional(traditional: traditional,),
        Meat(meat: meat,),
        Toppings(toppings: toppings,),
        Juicies(juices: juices,),

      ],
    ), 'name': 'الكل'},
    {'widget': Traditional(traditional: traditional,), 'name': 'تقليدي'},
    {'widget': Meat(meat: meat,), 'name': 'اللحوم'},
    {'widget':Toppings(toppings: toppings,),'name':'إضافات'},
    {'widget': Juicies(juices: juices,), 'name': 'العصائر'},

  ];
  late Object? selectedPage = Column(
    children: [
      Traditional(traditional: traditional,),
      Meat(meat: meat,),
      Toppings(toppings: toppings,),
      Juicies(juices: juices,),

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
                 if (
                 val == Column(
                   children:  [
                     Traditional(traditional: traditional,),
                     Meat(meat: meat,),
                     Toppings(toppings: toppings,),
                     Juicies(juices: juices,),
                   ],
                  )
                 ) {
                   getSpieces({'category': 'عصائر'}, 'juices');
                   getSpieces({'category': 'لحوم'}, 'meat');
                   getSpieces({'category': 'اضافات'}, 'toppings');
                   getSpieces({'category': 'تقليدي'}, 'traditional');

                 } else if (val == Traditional(traditional: traditional,)) {
                   getSpieces({'category': 'تقليدي'}, 'traditional');
                 } else if (val == Meat(meat: meat,)) {
                   getSpieces({'category': 'لحوم'}, 'meat');
                 } else if (val == Toppings(toppings: toppings,)) {
                   getSpieces({'category': 'اضافات'}, 'toppings');
                  } else {
                   getSpieces({'category': 'عصائر'}, 'juices');
                 }
               });
            },
            items: Pages
                .map((page) => DropdownMenuItem(
                value: page['widget'],
                child: Text('${page['name']}')
            )).toList(),
            validator: FormBuilderValidators.required(errorText: "الرجاء ادخال جميع الجقول"),
          ),
        ),
        SizedBox(height: 20,),

        selectedPage as Widget

      ],
    );
  }
}
