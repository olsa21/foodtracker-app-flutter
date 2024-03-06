import 'package:equatable/equatable.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';

class MealEntity with EquatableMixin {
  final FoodEntity food;
  final LogEntity log;

  MealEntity({required this.food, required this.log});

  @override
  List<Object?> get props => [food, log];
}
