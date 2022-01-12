import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './categories_screen.dart';
import './favorite_screen.dart';
import '../providers/language_provider.dart';
import '../providers/meal_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  static const String routeName = 'tabs_screen';

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late List<Map<String, Object>> _pages;

  int _selectedPageIndex = 0;

  void _selectPage(int value) {
    setState(() {
      _selectedPageIndex = value;
    });
  }

  @override
  void initState() {
    Provider.of<MealProvider>(context, listen: false).getPrefsData();
    Provider.of<ThemeProvider>(context, listen: false).getThemeMode();
    Provider.of<ThemeProvider>(context, listen: false).getThemeColors();
    Provider.of<LanguageProvider>(context, listen: false).getLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context, listen: true);
    _pages = [
      {
        'screen': const CategoriesScreen(),
        'title': lang.getText('categories').toString(),
      },
      {
        'screen': const FavoriteScreen(),
        'title': lang.getText('your_favorites').toString(),
      },
    ];

    return Directionality(
      textDirection: lang.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_pages[_selectedPageIndex]['title'].toString()),
        ),
        body: _pages[_selectedPageIndex]['screen'] as Widget,
        bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.category),
              label: lang.getText('categories').toString(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.star),
              label: lang.getText('your_favorites').toString(),
            ),
          ],
        ),
        drawer: const MainDrawer(),
      ),
    );
  }
}
