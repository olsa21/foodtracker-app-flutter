import 'package:dartz/dartz.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:foodtracker/3domain/repositories/FoodRepository.dart';

import '../failures/Failures.dart';

class FoodUseCase {
  final FoodRepository foodRepository;

  FoodUseCase({required this.foodRepository});

  /// To avoid code duplication in [FoodRepository.getFoodFromApi] method
  Future<Either<Failure, FoodEntity>> getFoodApiUseCase(String ean) async {
    return foodRepository.getFoodFromApi(ean);
  }
  /// To avoid code duplication in [FoodRepository.getFoodFromDb] method
  Future<Either<Failure, FoodEntity>> getFoodLocalUseCase(String ean) async {
    return foodRepository.getFoodFromDb(ean);
  }
  /// To avoid code duplication in [FoodRepository.getLog] method
  Future<Either<Failure, LogEntity>> getLogUseCase(int lId) async {
    return foodRepository.getLog(lId);
  }
  /// To avoid code duplication in [FoodRepository.getMealList] method
  Future<Either<Failure, List<MealEntity>>> getMealListUseCase(
      String date) async {
    return foodRepository.getMealList(date);
  }
  /// To avoid code duplication in [FoodRepository.getFoodListFromDb] method
  Future<Either<Failure, List<FoodEntity>>> getFoodListLocalUseCase(
      String? date) async {
    return foodRepository.getFoodListFromDb(date);
  }
  /// To avoid code duplication in [FoodRepository.getFoodFromApi] method
  Future<Either<Failure, List<FoodEntity>>> getFoodListApiUseCase(
      String searchName) async {
    return foodRepository.getFoodListFromApi(searchName);
  }
  /// To avoid code duplication in [FoodRepository.insertFood] method
  Future<Either<Failure, Unit>> insertFoodUseCase(FoodEntity foodEntity) async {
    return foodRepository.insertFood(foodEntity);
  }
  /// To avoid code duplication in [FoodRepository.updateLog] method
  Future<Either<Failure, Unit>> updateLogUseCase(LogEntity logEntity) async {
    return foodRepository.updateLog(logEntity);
  }
  /// To avoid code duplication in [FoodRepository.insertLog] method
  Future<Either<Failure, Unit>> insertLogUseCase(LogEntity logEntity) async {
    return foodRepository.insertLog(logEntity);
  }
  /// To avoid code duplication in [FoodRepository.deleteLog] method
  Future<Either<Failure, Unit>> deleteLogUseCase(int id) async {
    return foodRepository.deleteLog(id);
  }
  /// To avoid code duplication in [FoodRepository.syncProuductsDB] method
  Future<Either<Failure, int>> syncDatabaseUseCase() async {
    return foodRepository.syncProuductsDB();
  }
}
