import 'package:equatable/equatable.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';

class MealModel extends MealEntity with EquatableMixin {
  MealModel({required FoodEntity food, required LogEntity log})
      : super(food: food, log: log);

  @override
  // TODO: implement props
  List<Object?> get props => [food, log];

  factory MealModel.fromDomain(MealEntity mealEntity) {
    return MealModel(food: mealEntity.food, log: mealEntity.log);
  }
}
