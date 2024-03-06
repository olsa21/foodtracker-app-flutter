import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';

import '../../../2application/food/food_bloc.dart';
import '../../../3domain/entitites/LogEntity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../routes/routes_import.gr.dart';

class FoodAddCard extends StatelessWidget {
  final FoodEntity food;
  final String? date;

  const FoodAddCard({Key? key, required this.food, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            AutoRouter.of(context).push(FoodDetailPageRoute(food: food, date: date));
          },
          onLongPress: (){
            _showDeleteDialog(context: context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(food.name),
              Row(
                children: [
                  Text(food.brand),
                  const Spacer(),
                  //Dropdownbutton
                  Text("${food.calories} kcal"),
                  IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.successfullyAdded)));
                        LogEntity log = LogEntity(
                            ean: food.ean,
                            amount: 100,
                            type: "Snack",
                            date: date);
                        BlocProvider.of<FoodBloc>(context).add(
                            InsertFoodEvent(foodEntity: food, logEntity: log));
                      },
                      icon: const Icon(Icons.add_circle_outline))
                ],
              ),
              const Text("100 g"),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
      {required BuildContext context /*, required ControllerBloc bloc*/
      }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Title:"),
            content: const Text(
              "Do you want to remove the entry?",
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          );
        });
  }
}
