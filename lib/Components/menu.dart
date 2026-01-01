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
    'name': 'الكل'
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
    'name': 'تقليدي'
  },
  {
    'widget': Container(
      child: const MenuCategory(
        category: 'لحوم',
      ),
    ),
    'name': 'اللحوم'
  },
  {
    'widget': const SizedBox(
      child: MenuCategory(
        category: 'اضافات',
      ),
    ),
    'name': 'إضافات'
  },
  {
    'widget': const MenuCategory(
      category: 'عصائر',
    ),
    'name': 'العصائر'
  },
];
