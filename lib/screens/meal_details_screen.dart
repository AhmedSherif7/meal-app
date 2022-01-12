import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../providers/language_provider.dart';
import '../providers/meal_provider.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({Key? key}) : super(key: key);

  static const routeName = 'meal_details';

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context, listen: true);

    final bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mealId = ModalRoute.of(context)!.settings.arguments.toString();
    final selectedMeal = dummyMeals.firstWhere((meal) => meal.id == mealId);

    var secondaryColor = Theme.of(context).colorScheme.secondary;

    List<String> liIngredientsLi =
        lang.getText('ingredients-$mealId') as List<String>;
    Widget liIngredients = ListView.builder(
      itemCount: liIngredientsLi.length,
      itemBuilder: (context, index) => Card(
        color: secondaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            liIngredientsLi[index],
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );

    List<String> liStepsLi = lang.getText('steps-$mealId') as List<String>;
    Widget liSteps = ListView.builder(
      itemCount: liStepsLi.length,
      itemBuilder: (context, index) => Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('#${index + 1}'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              liStepsLi[index],
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const Divider(),
        ],
      ),
    );

    return Directionality(
      textDirection: lang.isEn ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title:
                      Text(lang.getText('meal-${selectedMeal.id}').toString()),
                  background: Hero(
                    tag: mealId,
                    child: InteractiveViewer(
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/place_holder.png'),
                        image: NetworkImage(selectedMeal.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                if (isLandScape)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          buildSectionTitle(
                              context, lang.getText('Ingredients').toString()),
                          buildContainer(liIngredients, context),
                        ],
                      ),
                      Column(
                        children: [
                          buildSectionTitle(
                              context, lang.getText('Steps').toString()),
                          buildContainer(liSteps, context),
                        ],
                      ),
                    ],
                  ),
                if (!isLandScape)
                  buildSectionTitle(
                      context, lang.getText('Ingredients').toString()),
                if (!isLandScape) buildContainer(liIngredients, context),
                if (!isLandScape)
                  buildSectionTitle(context, lang.getText('Steps').toString()),
                if (!isLandScape) buildContainer(liSteps, context),
              ])),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Provider.of<MealProvider>(context, listen: false)
              .toggleFavorites(mealId),
          child: Icon(
            Provider.of<MealProvider>(context, listen: true)
                    .isMealFavorite(mealId)
                ? Icons.star
                : Icons.star_border,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Container buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Container buildContainer(Widget child, BuildContext context) {
    final bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),
      height: isLandScape ? deviceHeight * 0.5 : deviceHeight * 0.25,
      width: isLandScape ? (deviceWidth * 0.5 - 30) : deviceWidth,
      child: child,
    );
  }
}
