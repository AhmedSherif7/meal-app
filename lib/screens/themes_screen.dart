import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/main_drawer.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({Key? key, this.fromOnBoarding = false}) : super(key: key);

  static const routeName = 'themes';
  final bool fromOnBoarding;

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context, listen: true);

    return Directionality(
      textDirection: lang.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                title: fromOnBoarding
                    ? null
                    : Text(lang.getText('theme_appBar_title').toString()),
                backgroundColor: fromOnBoarding
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).colorScheme.primary,
                elevation: fromOnBoarding ? 0 : 5,
                actions: fromOnBoarding
                    ? []
                    : [
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            items: [
                              DropdownMenuItem(
                                child: Row(
                                  children: [
                                    Icon(Icons.restore_outlined,
                                        color:
                                            Theme.of(context).iconTheme.color),
                                    const SizedBox(width: 8),
                                    Text(
                                      lang
                                          .getText('restore_default_settings')
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                value: 'reset',
                              ),
                            ],
                            onChanged: (itemIdentifier) {
                              if (itemIdentifier == 'reset') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext ctx) {
                                      return Directionality(
                                        textDirection: lang.isEn
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        child: AlertDialog(
                                          title: Text(
                                            lang
                                                .getText(
                                                    'theme_alert_dialog_title')
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                          content: Text(
                                            lang
                                                .getText(
                                                    'theme_alert_dialog_subtitle')
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Provider.of<ThemeProvider>(
                                                        context,
                                                        listen: false)
                                                    .restoreSettings();
                                                Navigator.pop(ctx);
                                              },
                                              child: Text(lang
                                                  .getText('ok')
                                                  .toString()),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                              },
                                              child: Text(lang
                                                  .getText('cancel')
                                                  .toString()),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              }
                            },
                          ),
                        )
                      ],
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    lang.getText('theme_screen_title').toString(),
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    lang.getText('theme_mode_title').toString(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                buildRadioListTile(
                    ThemeMode.system,
                    lang.getText('System_default_theme').toString(),
                    null,
                    context),
                buildRadioListTile(
                    ThemeMode.light,
                    lang.getText('light_theme').toString(),
                    Icons.wb_sunny_outlined,
                    context),
                buildRadioListTile(
                    ThemeMode.dark,
                    lang.getText('dark_theme').toString(),
                    Icons.nights_stay_outlined,
                    context),
                buildListTile(context, 'primary'),
                buildListTile(context, 'secondary'),
                SizedBox(height: fromOnBoarding ? 80 : 0),
              ])),
            ],
          ),
        ),
        drawer: fromOnBoarding ? null : const MainDrawer(),
      ),
    );
  }

  Widget buildRadioListTile(
      ThemeMode themeValue, String text, IconData? icon, BuildContext context) {
    final ThemeMode themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return RadioListTile(
      secondary: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      value: themeValue,
      groupValue: themeMode,
      onChanged: (newValue) =>
          Provider.of<ThemeProvider>(context, listen: false)
              .changeThemeMode(newValue),
      title: Text(text),
      activeColor: Provider.of<ThemeProvider>(context).secondaryColor,
    );
  }

  Widget buildListTile(BuildContext context, String text) {
    var lang = Provider.of<LanguageProvider>(context, listen: true);
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var secondaryColor =
        Provider.of<ThemeProvider>(context, listen: true).secondaryColor;

    return ListTile(
      title: text == 'primary'
          ? Text(lang.getText('primary').toString())
          : Text(lang.getText('secondary').toString()),
      trailing: CircleAvatar(
        backgroundColor: text == 'primary' ? primaryColor : secondaryColor,
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                elevation: 4,
                titlePadding: const EdgeInsets.all(0),
                contentPadding: const EdgeInsets.all(0),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: text == 'primary'
                        ? Provider.of<ThemeProvider>(context, listen: true)
                            .primaryColor
                        : Provider.of<ThemeProvider>(context, listen: true)
                            .secondaryColor,
                    onColorChanged: (newColor) =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .changeColors(newColor, text == 'primary' ? 1 : 2),
                    colorPickerWidth: 300,
                    pickerAreaHeightPercent: 0.7,
                    enableAlpha: false,
                    displayThumbColor: true,
                    labelTypes: const [],
                  ),
                ),
              );
            });
      },
    );
  }
}
