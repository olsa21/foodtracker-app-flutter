import 'package:dartz/dartz.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:foodtracker/3domain/failures/Failures.dart';
import 'package:foodtracker/3domain/repositories/FoodRepository.dart';
import 'package:foodtracker/4infrastructure/datasources/FoodLocalDataSource.dart';
import 'package:foodtracker/4infrastructure/datasources/FoodRemoteDataSource.dart';
import 'package:foodtracker/4infrastructure/models/FoodModel.dart';
import 'package:foodtracker/4infrastructure/models/LogModel.dart';
import 'package:logger/logger.dart';

import '../exceptions/exceptions.dart';

class FoodRepositoryImpl extends FoodRepository {
  final FoodRemoteDataSource foodRemoteDataSource;
  final FoodLocalDataSource foodLocalDataSource;

  FoodRepositoryImpl(
      {required this.foodRemoteDataSource, required this.foodLocalDataSource});

  //final FoodLocalDataSource foodLocalDataSource;
  //final Connectivity connectivity;

  @override
  Future<Either<Failure, FoodEntity>> getFoodFromApi(String ean) async {
    final FoodEntity foodEntity;
    try {
      foodEntity = await foodRemoteDataSource.getFoodFromApi(ean);
      return Right(foodEntity);
    } catch (e) {
      Logger().e(e);
      if (e is ServerException) {
        return Left(ServerFailure());
      } else if (e is ServerTimeoutException) {
        return Left(ServerTimeoutFailure());
      } else if (e is NoConnectionException) {
        return Left(NoConnectionFailure());
      }  else {
        return Left(GeneralFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getFoodListFromApi(
      String name) async {
    final List<FoodEntity> foodEntityList;
    try {
      foodEntityList = await foodRemoteDataSource.getFoodListFromApi(name);
      return Right(foodEntityList);
    } catch (e) {
      Logger().e(e);
      if (e is ServerException) {
        return Left(ServerFailure());
      } else if (e is ServerTimeoutException) {
        return Left(ServerTimeoutFailure());
      } else if (e is NoConnectionException) {
        return Left(NoConnectionFailure());
      } else if (e is EmptySearchException) {
        return Right([]);
      }else {
        return Left(GeneralFailure());
      }
    }
  }

  @override
  Future<Either<Failure, FoodEntity>> getFoodFromDb(String ean) async {
    final FoodEntity foodEntity;
    try {
      foodEntity = await foodLocalDataSource.getFood(ean);
      return Right(foodEntity);
    } catch (e) {
      Logger().e(e);
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, List<FoodEntity>>> getFoodListFromDb(
      String? date) async {
    final List<FoodEntity> foodEntityList;
    try {
      foodEntityList = await foodLocalDataSource.getFoodList(date);
      return Right(foodEntityList);
    } catch (e) {
      Logger().e(e);
      return Right(<FoodEntity>[]);
    }
  }

  @override
  Future<Either<Failure, List<MealEntity>>> getMealList(String date) async {
    final List<MealEntity> mealEntityList;
    try {
      mealEntityList = await foodLocalDataSource.getMealList(date);
      return Right(mealEntityList);
    } catch (e) {
      if (e is ResultEmptyException) {
        Logger().e("${e.runtimeType}: $e");
        return Right(<MealEntity>[]);
      }
      print(e.runtimeType);
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> insertFood(FoodEntity foodEntity) async {
    final foodModel = FoodModel.fromDomain(foodEntity);

    try {
      int affectedRows = await foodLocalDataSource.insertToFoodTable(foodModel);
      if (affectedRows == 1) {
        return Right(unit);
      }
    } catch (e) {
      print("${foodEntity.ean} already in table");
      return Left(DatabaseFailure());
    }

    return Left(DatabaseFailure());
  }

  @override
  Future<Either<Failure, Unit>> insertLog(LogEntity logEntity) async {
    final logModel = LogModel.fromDomain(logEntity);

    try {
      int affectedRows = await foodLocalDataSource.insertToLogTable(logModel);
      if (affectedRows == 1) {
        return Right(unit);
      }
    } catch (e) {
      print(e);
      return Left(DatabaseFailure());
    }

    return Left(DatabaseFailure());
  }

  @override
  Future<Either<Failure, LogEntity>> getLog(int lId) async {
    final LogEntity logEntity;
    try {
      logEntity = await foodLocalDataSource.getLog(lId);
      return Right(logEntity);
    } catch (e) {
      Logger().e(e);
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteLog(int id) async {
    try {
      int affectedRows = await foodLocalDataSource.deleteLogInTable(id);
      if (affectedRows == 1) {
        return Right(unit);
      }
    } catch (e) {
      print(e);
    }

    return Left(DatabaseFailure());
  }

  @override
  Future<Either<Failure, Unit>> updateLog(LogEntity logEntity) async {
    try {
      int affectedRows = await foodLocalDataSource
          .updateLogInTable(LogModel.fromDomain(logEntity));
      if (affectedRows == 1) {
        return Right(unit);
      } else {
        return Left(DatabaseFailure());
      }
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> syncProuductsDB() async {
    Map<String, FoodEntity> savedProducts;
    int counter = 0;
    try{
      // 1. Get all current saved products
      savedProducts = (await foodLocalDataSource.getFoodList(null)).asMap().map((key, value) => MapEntry(value.ean, value));
      //list to map

      // 2. Get all products from API
      for(var key in savedProducts.keys){
        savedProducts[key] = await foodRemoteDataSource.getFoodFromApi(savedProducts[key]!.ean);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // 3. Update all products in DB
      for(var key in savedProducts.keys){
        (await foodLocalDataSource.updateFoodInTable(FoodModel.fromDomain(savedProducts[key]!))) == 1 ? counter++ : null;
      }
      //print("Updated $counter products");
      return Right(counter);
    }catch(e){
      return Left(DatabaseFailure());
    }
  }
}
