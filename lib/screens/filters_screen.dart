import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/meal_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({Key? key, this.fromOnBoarding = false})
      : super(key: key);

  static const routeName = 'filters';
  final bool fromOnBoarding;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, bool> currentFilters =
        Provider.of<MealProvider>(context).filters;
    var lang = Provider.of<LanguageProvider>(context, listen: true);

    return Directionality(
      textDirection: lang.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                title: widget.fromOnBoarding
                    ? null
                    : Text(lang.getText('filters_appBar_title').toString()),
                backgroundColor: widget.fromOnBoarding
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).colorScheme.primary,
                elevation: widget.fromOnBoarding ? 0 : 5,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    lang.getText('filters_screen_title').toString(),
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                buildSwitchListTile(
                  lang.getText('Gluten-free').toString(),
                  lang.getText('Gluten-free-sub').toString(),
                  currentFilters['gluten']!,
                  (newValue) {
                    setState(() {
                      currentFilters['gluten'] = newValue;
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    });
                  },
                ),
                buildSwitchListTile(
                  lang.getText('Lactose-free').toString(),
                  lang.getText('Lactose-free_sub').toString(),
                  currentFilters['lactose']!,
                  (newValue) {
                    setState(() {
                      currentFilters['lactose'] = newValue;
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    });
                  },
                ),
                buildSwitchListTile(
                  lang.getText('Vegetarian').toString(),
                  lang.getText('Vegetarian-sub').toString(),
                  currentFilters['vegetarian']!,
                  (newValue) {
                    setState(() {
                      currentFilters['vegetarian'] = newValue;
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    });
                  },
                ),
                buildSwitchListTile(
                  lang.getText('Vegan').toString(),
                  lang.getText('Vegan-sub').toString(),
                  currentFilters['vegan']!,
                  (newValue) {
                    setState(() {
                      currentFilters['vegan'] = newValue;
                      Provider.of<MealProvider>(context, listen: false)
                          .setFilters();
                    });
                  },
                ),
                SizedBox(height: widget.fromOnBoarding ? 80 : 0),
              ])),
            ],
          ),
        ),
        drawer: widget.fromOnBoarding ? null : const MainDrawer(),
      ),
    );
  }

  SwitchListTile buildSwitchListTile(String title, String subtitle,
      bool currentValue, Function(bool) updateValue) {
    return SwitchListTile(
      value: currentValue,
      onChanged: updateValue,
      title: Text(title),
      subtitle: Text(subtitle),
      activeColor: Theme.of(context).colorScheme.secondary,
      inactiveTrackColor:
          Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
              ? null
              : Colors.black,
    );
  }
}
