import 'package:flutter/material.dart';
import 'package:ashkerty_food/Components/menu_categ.dart';

//list of pages
List menuPages = [
  {
//------------------All Menu Items-----------------------------------
    'widget': const Column(
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
    ),
    'name': 'الكل',
    'icon': Icons.restaurant_menu,
  },
  //---------------Menu Items------------------------------------------
  {
    'widget': const Column(
      children: [
        MenuCategory(
          category: 'تقليدي',
        ),
      ],
    ),
    'name': 'تقليدي',
    'icon': Icons.fastfood,
  },
  {
    'widget': Container(
      child: const MenuCategory(
        category: 'لحوم',
      ),
    ),
    'name': 'اللحوم',
    'icon': Icons.set_meal,
  },
  {
    'widget': const MenuCategory(
      category: 'عصائر',
    ),
    'name': 'العصائر',
    'icon': Icons.local_drink,
  },
  {
    'widget': const SizedBox(
      child: MenuCategory(
        category: 'اضافات',
      ),
    ),
    'name': 'إضافات',
    'icon': Icons.add_circle,
  },
];
