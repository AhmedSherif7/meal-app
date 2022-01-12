import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/language_provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  const CategoryMealsScreen({Key? key}) : super(key: key);

  static const routeName = 'category_meals';

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late List<Meal> displayedMeals;
  late final String categoryId;

  @override
  void didChangeDependencies() {
    final List<Meal> availableMeals =
        Provider.of<MealProvider>(context).availableMeals;
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    categoryId = routeArgs['id']!;
    displayedMeals = availableMeals
        .where((meal) => meal.categories.contains(categoryId))
        .toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    var lang = Provider.of<LanguageProvider>(context, listen: true);

    return Directionality(
      textDirection: lang.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(lang.getText('cat-$categoryId').toString())),
        body: SafeArea(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: deviceWidth <= 400 ? 400 : 500,
              childAspectRatio: 2.7 / 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemCount: displayedMeals.length,
            itemBuilder: (context, index) {
              return MealItem(
                id: displayedMeals[index].id,
                imageUrl: displayedMeals[index].imageUrl,
                duration: displayedMeals[index].duration,
                complexity: displayedMeals[index].complexity,
                affordability: displayedMeals[index].affordability,
              );
            },
          ),
        ),
      ),
    );
  }
}
