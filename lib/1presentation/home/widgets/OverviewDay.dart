import 'package:flutter/material.dart';
import 'package:foodtracker/1presentation/home/widgets/CustomCircularProgress.dart';
import 'package:foodtracker/1presentation/home/widgets/ProgressNutrition.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OverviewDay extends StatelessWidget {
  const OverviewDay({Key? key, required this.mealList}) : super(key: key);
  final List<MealEntity> mealList;

  @override
  Widget build(BuildContext context) {
    int target = 2300;
    int burned = 0;
    int calories = 0;
    int carbs = 0;
    int proteins = 0;
    int fat = 0;

    for (var value in mealList) {
      calories += (value.food.calories * (value.log.amount / 100)).round();
      carbs += (value.food.carbs * (value.log.amount / 100)).round();
      proteins += (value.food.proteins * (value.log.amount / 100)).round();
      fat += (value.food.fat * (value.log.amount / 100)).round();
    }

    final intl = AppLocalizations.of(context)!;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: (MediaQuery.of(context).platformBrightness == Brightness.dark)
              ? Colors.green
              : Colors.greenAccent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "$calories kcal \n" + intl.consumed,
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: CustomCircularProgress(
                    current: calories,
                    maximum: target,
                  )),
                  Expanded(
                      child: Text(
                    "$burned kcal " + intl.burned,
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: ProgressNutrition(
                          title: intl.carbs, current: carbs, maximum: 120)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ProgressNutrition(
                          title: intl.protein, current: proteins, maximum: 120)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ProgressNutrition(
                          title: intl.fat, current: fat, maximum: 120)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
