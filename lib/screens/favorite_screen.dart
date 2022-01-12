import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_item.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Meal> favoriteMeals =
        Provider.of<MealProvider>(context).favoriteMeals;

    final double deviceWidth = MediaQuery.of(context).size.width;

    if (favoriteMeals.isEmpty) {
      return const Center(
        child: Text('You have no favorites yet, start adding some!'),
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: deviceWidth <= 400 ? 400 : 500,
          childAspectRatio: 2.7 / 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          return MealItem(
            id: favoriteMeals[index].id,
            imageUrl: favoriteMeals[index].imageUrl,
            duration: favoriteMeals[index].duration,
            complexity: favoriteMeals[index].complexity,
            affordability: favoriteMeals[index].affordability,
          );
        },
      );
    }
  }
}
