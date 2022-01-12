import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './providers/language_provider.dart';
import './providers/meal_provider.dart';
import './providers/theme_provider.dart';
import './screens/category_meals_screen.dart';
import './screens/filters_screen.dart';
import './screens/meal_details_screen.dart';
import './screens/on_boarding_screen.dart';
import './screens/tabs_screen.dart';
import './screens/themes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget homeScreen = prefs.getBool('watched') ?? false
      ? const TabsScreen()
      : const OnBoardingScreen();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (BuildContext context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<MealProvider>(
          create: (BuildContext context) => MealProvider(),
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (BuildContext context) => LanguageProvider(),
        ),
      ],
      child: MyApp(homeScreen: homeScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget homeScreen;

  const MyApp({Key? key, required this.homeScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Provider.of<ThemeProvider>(context).primaryColor;
    var secondaryColor = Provider.of<ThemeProvider>(context).secondaryColor;
    var themeMode = Provider.of<ThemeProvider>(context).themeMode;

    return MaterialApp(
      title: 'Meal App',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        fontFamily: 'Raleway',
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: secondaryColor),
        cardColor: Colors.white,
        shadowColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: const TextStyle(color: Color.fromRGBO(20, 50, 50, 1)),
              headline6: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
      ),
      darkTheme: ThemeData(
        canvasColor: const Color.fromRGBO(14, 22, 33, 1),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primaryColor)
            .copyWith(secondary: secondaryColor),
        cardColor: const Color.fromRGBO(35, 34, 31, 1),
        shadowColor: Colors.black54,
        unselectedWidgetColor: Colors.white70,
        iconTheme: const IconThemeData(color: Colors.white70),
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: const TextStyle(color: Colors.white70),
              headline6: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
      ),
      routes: {
        '/': (context) => homeScreen,
        TabsScreen.routeName: (context) => const TabsScreen(),
        CategoryMealsScreen.routeName: (context) => const CategoryMealsScreen(),
        MealDetailsScreen.routeName: (context) => const MealDetailsScreen(),
        FiltersScreen.routeName: (context) => const FiltersScreen(),
        ThemesScreen.routeName: (context) => const ThemesScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal App'),
      ),
      body: null,
    );
  }
}
