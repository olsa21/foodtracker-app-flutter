import 'package:flutter/material.dart';
import 'package:foodtracker/1presentation/home/widgets/FoodCard.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OverviewMeal extends StatelessWidget {
  final List<MealEntity> list;
  final String title;

  const OverviewMeal({Key? key, required this.list, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int calories = 0;

    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    for (var value in list) {
      calories += (value.food.calories * (value.log.amount / 100)).round();
    }

    final intl = AppLocalizations.of(context)!;
    return Material(
      elevation: 5,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: (isDark) ? Colors.white : Colors.black),
            ),
            Text(
              "$calories " + intl.calories,
              style: TextStyle(color: (isDark) ? Colors.white : Colors.black),
            ),
          ],
        ),
        children: _getChildren(list),
        textColor: Colors.black,
        collapsedTextColor: Colors.black,
        collapsedIconColor: Colors.black,
        iconColor: Colors.black,
        backgroundColor: Colors.grey,
        collapsedBackgroundColor: Colors.grey,
      ),
    );
  }

  List<Widget> _getChildren(List<MealEntity> list) => List<Widget>.generate(
      list.length,
      (i) => FoodCard(
            meal: list[i],
          ));
}
