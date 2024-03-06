import 'package:dartz/dartz.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:foodtracker/3domain/failures/Failures.dart';

abstract class FoodRepository {
  /// Get food from api with [ean]
  Future<Either<Failure, FoodEntity>> getFoodFromApi(String ean);

  ///Get saved Product from local database with [ean]
  Future<Either<Failure, FoodEntity>> getFoodFromDb(String ean);

  ///Get Product from API matching [name]
  Future<Either<Failure, List<FoodEntity>>> getFoodListFromApi(String name);

  ///Get saved Products from local database with optional [date]
  Future<Either<Failure, List<FoodEntity>>> getFoodListFromDb(String? date);

  ///Get Meal from database with given [date]
  Future<Either<Failure, List<MealEntity>>> getMealList(String date);

  ///Get Log from database with given ID [lId]
  Future<Either<Failure, LogEntity>> getLog(int lId);

  ///Insert Product into local database with [food]
  Future<Either<Failure, Unit>> insertFood(FoodEntity foodEntity);

  ///Insert Log into local database with [logEntity]
  Future<Either<Failure, Unit>> insertLog(LogEntity logEntity);

  ///Update Log in local database with [logEntity]
  Future<Either<Failure, Unit>> updateLog(LogEntity logEntity);

  ///Delete Log from local database with given [id]
  Future<Either<Failure, Unit>> deleteLog(int id);

  ///Sync product database to get the latest data
  Future<Either<Failure, int>> syncProuductsDB();
///
}
