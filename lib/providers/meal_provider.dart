import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummy_data.dart';
import '../models/category.dart';
import '../models/meal.dart';

class MealProvider with ChangeNotifier {
  List<Meal> availableMeals = dummyMeals;
  List<Meal> favoriteMeals = [];
  List<Category> availableCategories = dummyCategories;
  late final List<String> favMealsId;

  Map<String, bool> filters = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };

  void setFilters() async {
    availableMeals = dummyMeals.where((meal) {
      if (filters['gluten']! && !meal.isGlutenFree) {
        return false;
      } else if (filters['lactose']! && !meal.isLactoseFree) {
        return false;
      } else if (filters['vegetarian']! && !meal.isVegetarian) {
        return false;
      } else if (filters['vegan']! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    List<Category> ac = [];
    for (var meal in availableMeals) {
      for (var categoryId in meal.categories) {
        for (var category in dummyCategories) {
          if (category.id == categoryId) {
            if (!ac.any((category) => category.id == categoryId)) {
              ac.add(category);
            }
          }
        }
      }
    }
    availableCategories = ac;

    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('gluten', filters['gluten']!);
    prefs.setBool('lactose', filters['lactose']!);
    prefs.setBool('vegetarian', filters['vegetarian']!);
    prefs.setBool('vegan', filters['vegan']!);
  }

  void getPrefsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    filters['gluten'] = prefs.getBool('gluten') ?? false;
    filters['lactose'] = prefs.getBool('lactose') ?? false;
    filters['vegetarian'] = prefs.getBool('vegetarian') ?? false;
    filters['vegan'] = prefs.getBool('vegan') ?? false;

    favMealsId = prefs.getStringList('favMealsId') ?? [];
    for (var mealId in favMealsId) {
      favoriteMeals.add(dummyMeals.firstWhere((meal) => meal.id == mealId));
    }

    List<Meal> fm = [];
    for (var favoriteMeal in favoriteMeals) {
      for (var availableMeal in availableMeals) {
        if (favoriteMeal.id == availableMeal.id) {
          fm.add(favoriteMeal);
        }
      }
    }
    favoriteMeals = fm;

    notifyListeners();
  }

  void toggleFavorites(String mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final mealIndex = favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (mealIndex >= 0) {
      favoriteMeals.removeAt(mealIndex);
      favMealsId.remove(mealId);
    } else {
      favoriteMeals.add(dummyMeals.firstWhere((meal) => meal.id == mealId));
      favMealsId.add(mealId);
    }
    notifyListeners();

    prefs.setStringList('favMealsId', favMealsId);
  }

  bool isMealFavorite(String mealId) {
    return favoriteMeals.any((meal) => meal.id == mealId);
  }
}
