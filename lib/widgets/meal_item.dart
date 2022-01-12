import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/language_provider.dart';
import '../screens/meal_details_screen.dart';

class MealItem extends StatelessWidget {
  const MealItem({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.duration,
    required this.complexity,
    required this.affordability,
  }) : super(key: key);

  final String id;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  void selectMeal(BuildContext context) {
    Navigator.of(context).pushNamed(
      MealDetailsScreen.routeName,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LanguageProvider>(context, listen: true);

    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: id,
                    child: InteractiveViewer(
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/place_holder.png'),
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Text(
                      lang.getText('meal-$id').toString(),
                      style: const TextStyle(fontSize: 26, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule,
                          color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 6),
                      Text('$duration ${lang.getText('min').toString()}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.work,
                          color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 6),
                      Text(lang.getText('$complexity').toString()),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 6),
                      Text(lang.getText('$affordability').toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
