import 'package:flutter/material.dart';
import 'package:ashkerty_food/Components/menu_categ.dart';

// Map Arabic category names (or keys) to icons. If a name isn't present,
// use the default icon when generating pages.
final Map<String, IconData> arabicIconMap = {
  'الكل': Icons.restaurant_menu,
  'كفتة': Icons.no_meals,
  'شاورما': Icons.set_meal,
  'اقاشي': Icons.set_meal_outlined,
  'عصائر': Icons.local_drink,
  'اضافات': Icons.add_circle,
};

// //list of pages
// List menuPages = [
//   {
// //------------------All Menu Items-----------------------------------
//     'widget': const Column(
//       children: [
//         MenuCategory(
//           category: 'الكل',
//           isAll: true,
//         ),
//       ],
//     ),
//     'name': 'الكل',
//     'icon': Icons.restaurant_menu,
//   },
//   //---------------Menu Items------------------------------------------

//   {
//     'widget': Container(
//       child: const MenuCategory(
//         category: 'لحوم',
//         isAll: false,
//       ),
//     ),
//     'name': 'لحوم',
//     'icon': Icons.no_meals,
//   },
//   {
//     'widget': Container(
//       child: const MenuCategory(
//         category: 'شاورما',
//         isAll: false,
//       ),
//     ),
//     'name': 'شاورما',
//     'icon': Icons.set_meal,
//   },
//   {
//     'widget': const MenuCategory(
//       category: 'عصائر',
//       isAll: false,
//     ),
//     'name': 'عصائر',
//     'icon': Icons.local_drink,
//   },
//   {
//     'widget': const SizedBox(
//       child: MenuCategory(
//         category: 'اضافات',
//         isAll: false,
//       ),
//     ),
//     'name': 'اضافات',
//     'icon': Icons.add_circle,
//   },
// ];

// Generate menuPages dynamically from a categories list (from API).
// Each category item is expected to contain a `name` or `title` field.
List generateMenuPages(List categories) {
  final List pages = [];

  // Always include 'all' page first
  pages.add({
    'widget': const Column(
      children: [
        MenuCategory(
          category: 'الكل',
          isAll: true,
        ),
      ],
    ),
    'name': 'الكل',
    'icon': arabicIconMap['الكل'] ?? Icons.restaurant_menu,
  });

  for (final cat in categories) {
    final String name =
        (cat is Map) ? (cat['name'] ?? cat['title'] ?? '') : cat.toString();

    if (name.trim().isEmpty) continue;

    final icon = arabicIconMap[name] ?? Icons.table_restaurant;

    pages.add({
      'widget': Container(
        // give each MenuCategory a unique key so Flutter treats them as
        // distinct widgets and resets state when switching categories
        child: MenuCategory(
          key: ValueKey('menu_category_$name'),
          category: name,
          isAll: false,
        ),
      ),
      'name': name,
      'icon': icon,
    });
  }

  return pages;
}
