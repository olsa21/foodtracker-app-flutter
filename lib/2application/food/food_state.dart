part of 'food_bloc.dart';

@immutable
abstract class FoodState {}

class FoodInitial extends FoodState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class FoodStateLoading extends FoodState with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class FoodStateFoodLoaded extends FoodState with EquatableMixin {
  final FoodEntity foodEntity;

  FoodStateFoodLoaded({required this.foodEntity});

  @override
  List<Object?> get props => [foodEntity];
}

class FoodStateFoodListLoaded extends FoodState with EquatableMixin {
  final List<FoodEntity> foodEntityList;

  FoodStateFoodListLoaded({required this.foodEntityList});

  @override
  List<Object?> get props => [foodEntityList];
}

class FoodStateRemoteFoodListLoaded extends FoodState with EquatableMixin {
  final List<FoodEntity> foodEntityList;

  FoodStateRemoteFoodListLoaded({required this.foodEntityList});

  @override
  List<Object?> get props => [foodEntityList];
}

class FoodStateMealListLoaded extends FoodState with EquatableMixin {
  final List<MealEntity> mealEntityList;

  FoodStateMealListLoaded({required this.mealEntityList});

  @override
  List<Object?> get props => [mealEntityList];
}

class FoodStateError extends FoodState with EquatableMixin {
  final String message;

  FoodStateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SuccessState extends FoodState with EquatableMixin {
  @override
  List<Object?> get props => [];
}
