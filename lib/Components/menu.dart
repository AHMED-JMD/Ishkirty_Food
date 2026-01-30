import 'package:flutter/material.dart';
import 'package:ashkerty_food/Components/menu_categ.dart';

//list of pages
List menuPages = [
  {
//------------------All Menu Items-----------------------------------
    'widget': const Column(
      children: [
        MenuCategory(
          category: 'الكل',
          isAll: true,
        ),
      ],
    ),
    'name': 'الكل',
    'icon': Icons.restaurant_menu,
  },
  //---------------Menu Items------------------------------------------

  {
    'widget': Container(
      child: const MenuCategory(
        category: 'كفتة',
        isAll: false,
      ),
    ),
    'name': 'كفتة',
    'icon': Icons.no_meals,
  },
  {
    'widget': Container(
      child: const MenuCategory(
        category: 'شاورما',
        isAll: false,
      ),
    ),
    'name': 'شاورما',
    'icon': Icons.set_meal,
  },
  {
    'widget': const MenuCategory(
      category: 'عصائر',
      isAll: false,
    ),
    'name': 'العصائر',
    'icon': Icons.local_drink,
  },
  {
    'widget': const SizedBox(
      child: MenuCategory(
        category: 'اضافات',
        isAll: false,
      ),
    ),
    'name': 'إضافات',
    'icon': Icons.add_circle,
  },
];
