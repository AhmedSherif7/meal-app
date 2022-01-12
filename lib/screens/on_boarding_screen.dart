import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/filters_screen.dart';
import '../screens/tabs_screen.dart';
import '../screens/themes_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    var lang = Provider.of<LanguageProvider>(context, listen: true);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('assets/images/image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 300,
                      color: Theme.of(context).shadowColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Text(
                        lang.getText('drawer_name').toString(),
                        style: Theme.of(context).textTheme.headline4,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Container(
                      width: 300,
                      color: Theme.of(context).shadowColor,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            lang.getText('drawer_switch_title').toString(),
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lang.getText('drawer_switch_item2').toString(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Switch(
                                value: lang.isEn,
                                onChanged: (newLang) =>
                                    Provider.of<LanguageProvider>(context,
                                            listen: false)
                                        .changeLang(newLang),
                                activeColor: Provider.of<ThemeProvider>(context)
                                    .secondaryColor,
                              ),
                              Text(
                                lang.getText('drawer_switch_item1').toString(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const ThemesScreen(fromOnBoarding: true),
              const FiltersScreen(fromOnBoarding: true),
            ],
            onPageChanged: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
          ),
          Indicator(_currentIndex),
          Builder(builder: (ctx) {
            return Align(
              alignment: const Alignment(0, 0.85),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: lang.isEn
                        ? MaterialStateProperty.all(const EdgeInsets.all(7))
                        : MaterialStateProperty.all(const EdgeInsets.all(0)),
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                  ),
                  onPressed: () async {
                    Navigator.of(context)
                        .pushReplacementNamed(TabsScreen.routeName);

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('watched', true);
                  },
                  child: Text(
                    lang.getText('start').toString(),
                    style: TextStyle(
                      color: useWhiteForeground(primaryColor)
                          ? Colors.white
                          : Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildContainer(context, 0),
          buildContainer(context, 1),
          buildContainer(context, 2),
        ],
      ),
    );
  }

  Widget buildContainer(BuildContext context, int i) {
    return index == i
        ? Icon(
            Icons.star,
            color: Theme.of(context).colorScheme.primary,
          )
        : Container(
            margin: const EdgeInsets.all(4),
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          );
  }
}
