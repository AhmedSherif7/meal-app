import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/filters_screen.dart';
import '../screens/tabs_screen.dart';
import '../screens/themes_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context, listen: true);
    return Directionality(
      textDirection: lang.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Drawer(
        elevation: 0,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment:
                    lang.isEn ? Alignment.centerLeft : Alignment.centerRight,
                color: Theme.of(context).colorScheme.secondary,
                child: Text(
                  lang.getText('drawer_name').toString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildListTile(
                Icons.restaurant,
                lang.getText('drawer_item1').toString(),
                context,
                () => Navigator.of(context)
                    .pushReplacementNamed(TabsScreen.routeName),
              ),
              buildListTile(
                Icons.settings,
                lang.getText('drawer_item2').toString(),
                context,
                () => Navigator.of(context)
                    .pushReplacementNamed(FiltersScreen.routeName),
              ),
              buildListTile(
                Icons.color_lens,
                lang.getText('drawer_item3').toString(),
                context,
                () => Navigator.of(context)
                    .pushReplacementNamed(ThemesScreen.routeName),
              ),
              Divider(
                height: 10,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.light
                    ? Colors.black54
                    : Colors.white70,
              ),
              Container(
                alignment:
                    lang.isEn ? Alignment.centerLeft : Alignment.centerRight,
                padding: lang.isEn
                    ? const EdgeInsets.only(top: 20, left: 22)
                    : const EdgeInsets.only(top: 20, right: 22),
                child: Text(
                  lang.getText('drawer_switch_title').toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      lang.getText('drawer_switch_item2').toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Switch(
                      value: lang.isEn,
                      onChanged: (newLang) =>
                          Provider.of<LanguageProvider>(context, listen: false)
                              .changeLang(newLang),
                      activeColor:
                          Provider.of<ThemeProvider>(context).secondaryColor,
                    ),
                    Text(
                      lang.getText('drawer_switch_item1').toString(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10,
                color: Provider.of<ThemeProvider>(context).themeMode ==
                        ThemeMode.light
                    ? Colors.black54
                    : Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, BuildContext context,
      Function() tabHandler) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).textTheme.bodyText1!.color,
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tabHandler,
    );
  }
}
