part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {}

class FoodRequestedEvent extends FoodEvent {
  final String ean;
  final String? date;

  FoodRequestedEvent({required this.ean, this.date});
}

class LocalFoodListRequestedEvent extends FoodEvent {
  final String? date;

  LocalFoodListRequestedEvent({required this.date});
}

class RemoteFoodListRequestedEvent extends FoodEvent {
  final String searchName;

  RemoteFoodListRequestedEvent({required this.searchName});
}

class InsertFoodEvent extends FoodEvent {
  final FoodEntity foodEntity;
  final LogEntity logEntity;

  InsertFoodEvent({required this.foodEntity, required this.logEntity});
}

class UpdateFoodLogEvent extends FoodEvent {
  final LogEntity logEntity;

  UpdateFoodLogEvent({required this.logEntity});
}

class MealListRequestedEvent extends FoodEvent {
  final String date;

  MealListRequestedEvent({required this.date});
}

class DeleteLogEvent extends FoodEvent {
  final int id;

  DeleteLogEvent({required this.id});
}

class SyncDatabaseEvent extends FoodEvent{}
