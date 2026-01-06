import 'package:ashkerty_food/API/Spieces.dart';
import 'package:ashkerty_food/Components/menu.dart';
import 'package:ashkerty_food/Components/menu_categ.dart';
import 'package:flutter/material.dart';

class MenuNav extends StatefulWidget {
  const MenuNav({super.key});

  @override
  State<MenuNav> createState() => _MenuNavState();
}

class _MenuNavState extends State<MenuNav> {
  bool isLoading = false;
  int selectedIndex = 0;
  late Widget selectedPage;

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

  @override
  void initState() {
    super.initState();
    // initialize selectedPage to the first menu page widget (if available)
    if (menuPages.isNotEmpty) {
      selectedPage = menuPages[0]['widget'] as Widget;
      selectedIndex = 0;
    } else {
      selectedPage = const Column(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Vertical list of small clickable cards
        SizedBox(
          height: 110, // card height + padding
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              scrollDirection: Axis.horizontal,
              itemCount: menuPages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final page = menuPages[index];
                final bool isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      selectedPage = page['widget'] as Widget;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 185),
                    width: 140,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal.shade50 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.teal : Colors.grey.shade300,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          page['icon'] ?? Icons.restaurant_menu,
                          color:
                              isSelected ? Colors.teal : Colors.teal.shade400,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${page['name']}',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        selectedPage
      ],
    );
  }
}
