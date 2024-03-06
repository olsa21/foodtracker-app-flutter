import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';

import '../../../2application/food/food_bloc.dart';
import '../../routes/routes_import.gr.dart';

class FoodCard extends StatelessWidget {
  final MealEntity meal;

  const FoodCard({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = meal.food.name;
    final String brand = meal.food.brand;
    final int amount = meal.log.amount.round();
    final int calories = (meal.food.calories * (meal.log.amount / 100)).round();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            AutoRouter.of(context)
                .push(FoodDetailPageRoute(food: meal.food, log: meal.log));
          },
          onLongPress: () {
            _showDeletDialog(context: context, meal: meal);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Row(
                children: [
                  Text(brand),
                  const Spacer(),
                  Text("$calories kcal"),
                ],
              ),
              Text("$amount g"),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletDialog(
      {required BuildContext context /*, required ControllerBloc bloc*/,
      required MealEntity meal}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete Entry"),
            content: Text(
              "Would you like to delete\n\"${meal.food.name}\"?",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    BlocProvider.of<FoodBloc>(context)
                        .add(DeleteLogEvent(id: meal.log.id!));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete Entry",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
}
