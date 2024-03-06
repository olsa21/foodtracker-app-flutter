import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:foodtracker/3domain/failures/Failures.dart';
import 'package:foodtracker/3domain/repositories/FoodRepository.dart';
import 'package:foodtracker/4infrastructure/datasources/FoodLocalDataSource.dart';
import 'package:foodtracker/4infrastructure/datasources/FoodRemoteDataSource.dart';
import 'package:foodtracker/4infrastructure/exceptions/exceptions.dart';
import 'package:foodtracker/4infrastructure/models/FoodModel.dart';
import 'package:foodtracker/4infrastructure/models/LogModel.dart';
import 'package:foodtracker/4infrastructure/repositories/FoodRepositoryImpl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_repository_test.mocks.dart';

@GenerateMocks([FoodRemoteDataSource, FoodLocalDataSource])
void main(){
  late FoodRepository foodRepositoryWithMock;
  late MockFoodRemoteDataSource mockFoodRemoteDataSource;
  late MockFoodLocalDataSource mockFoodLocalDataSource;
  
  setUp((){
    mockFoodRemoteDataSource = MockFoodRemoteDataSource();
    mockFoodLocalDataSource = MockFoodLocalDataSource();
    foodRepositoryWithMock = FoodRepositoryImpl(foodRemoteDataSource: mockFoodRemoteDataSource, foodLocalDataSource: mockFoodLocalDataSource);
  });

  const String ean="123";
  final t_LogModel = LogModel.empty();
  final t_MealEntity = MealEntity(food: FoodEntity.empty(), log: LogModel.empty());
  final List<MealEntity> t_MealEntityList = [t_MealEntity, t_MealEntity];
  final t_FoodModel = FoodModel.empty();
  final FoodEntity t_FoodEntity = t_FoodModel;
  final List<FoodEntity> t_FoodModelList = [
    FoodEntity(
      ean: "3045140105502",//_code oder auch code
      name: "Alpenmilch", // product_name
      brand: "Milka", //brands
      imageUrl:
      "https://images.openfoodfacts.org/images/products/304/514/010/5502/front_de.297.400.jpg", //same
      servingSize: 16.7, //same
      calories: 530,
      fat: 29,
      fatSaturated: 18,
      carbs: 59,
      sugar: 58,
      proteins: 6.3,
      salt: 0.37,
    ),
    FoodEntity(
      ean: "7622210100917",
      name: "",
      brand: "Milka",
      imageUrl:
      "https://images.openfoodfacts.org/images/products/762/221/010/0917/front_de.75.400.jpg",
      servingSize: 20,
      calories: 507,
      fat: 24,
      fatSaturated: 12,
      carbs: 65,
      sugar:35,
      proteins: 5.7,
      salt: 0.6,
    ),
    FoodEntity(
      ean: "3045140118502",
      name: "Milka Ganze Nuss",
      brand: "Milka",
      imageUrl:
      "https://images.openfoodfacts.org/images/products/304/514/011/8502/front_de.31.400.jpg",
      servingSize: 16.7,
      calories: 556,
      fat: 36,
      fatSaturated: 15,
      carbs: 49,
      sugar: 47,
      proteins: 8.1,
      salt: 0.3,
    )
  ];

  final List<FoodEntity> t_FoodEntityList = [
    FoodEntity(
      ean: "3045140105502",
      name: "Alpenmilch",
      brand: "Milka",
      imageUrl:
      "https://images.openfoodfacts.org/images/products/304/514/010/5502/front_de.297.400.jpg", //same
      servingSize: 16.7,
      calories: 530,
      fat: 29,
      fatSaturated: 18,
      carbs: 59,
      sugar: 58,
      proteins: 6.3,
      salt: 0.37,
    ),
    FoodEntity(
      ean: "7622210100917",
      name: "",
      brand: "Milka",
      imageUrl:
      "https://images.openfoodfacts.org/images/products/762/221/010/0917/front_de.75.400.jpg",
      servingSize: 20,
      calories: 507,
      fat: 24,
      fatSaturated: 12,
      carbs: 65,
      sugar:35,
      proteins: 5.7,
      salt: 0.6,
    ),
    FoodEntity(
      ean: "3045140118502",
      name: "Milka Ganze Nuss",
      brand: "Milka",
      imageUrl:
      "https://images.openfoodfacts.org/images/products/304/514/011/8502/front_de.31.400.jpg",
      servingSize: 16.7,
      calories: 556,
      fat: 36,
      fatSaturated: 15,
      carbs: 49,
      sugar: 47,
      proteins: 8.1,
      salt: 0.3,
    )
  ];

  group("test methods from remote datasource", () {
    group("getFoodFromApi()", (){
      test("should return remote data if the call is successfull", ()async{
        // arrange
        when(mockFoodRemoteDataSource.getFoodFromApi(ean)).thenAnswer((_) async => t_FoodModel);

        // act
        //mockFoodRemoteDataSource.ean="123";
        final result = await foodRepositoryWithMock.getFoodFromApi(ean);


        // assert
        verify(mockFoodRemoteDataSource.getFoodFromApi(ean));
        expect(result, Right(t_FoodEntity));
        verifyNoMoreInteractions(mockFoodRemoteDataSource);
      });

      test("should return ServerFailure if datasource throws ServerException", ()async{

        //arrange
        when(mockFoodRemoteDataSource.getFoodFromApi(ean)).thenThrow(ServerException());

        //act
        //mockFoodRemoteDataSource.ean="123";
        final result = await foodRepositoryWithMock.getFoodFromApi(ean);

        //assert
        verify(mockFoodRemoteDataSource.getFoodFromApi(ean));
        expect(result, Left(ServerFailure()));
        verifyNoMoreInteractions(mockFoodRemoteDataSource);
      });

      test("should return ServerTimeoutFailure if datasource throws ServerTimeoutException", ()async{

        //arrange
        when(mockFoodRemoteDataSource.getFoodFromApi(ean)).thenThrow(ServerTimeoutException());

        //act
        //mockFoodRemoteDataSource.ean="123";
        final result = await foodRepositoryWithMock.getFoodFromApi(ean);

        //assert
        verify(mockFoodRemoteDataSource.getFoodFromApi(ean));
        expect(result, Left(ServerTimeoutFailure()));
        verifyNoMoreInteractions(mockFoodRemoteDataSource);
      });

      //todo test getFoodListFromApi
    });

    group("getFoodListFromApi()", (){

      test("should return remote data list if the call is successfull", ()async{
        // arrange
        when(mockFoodRemoteDataSource.getFoodListFromApi("name")).thenAnswer((_) async => t_FoodModelList);

        // act
        final result = await foodRepositoryWithMock.getFoodListFromApi("name");

        result.fold((l) => fail("test failed"), (r) {
          // assert
          verify(mockFoodRemoteDataSource.getFoodListFromApi("name"));
          expect(r, t_FoodEntityList);
          verifyNoMoreInteractions(mockFoodRemoteDataSource);
        });
      });

      test("should return server failure if datasource throws ServerTimeoutException", ()async{
        //arrange
        when(mockFoodRemoteDataSource.getFoodListFromApi("")).thenThrow(ServerTimeoutException());

        //act
        final result = await foodRepositoryWithMock.getFoodListFromApi("");

        //assert
        verify(mockFoodRemoteDataSource.getFoodListFromApi(""));
        expect(result, Left(ServerTimeoutFailure()));
        verifyNoMoreInteractions(mockFoodRemoteDataSource);
      });

      test("should return ServerTimeoutFailure if datasource throws ServerTimeoutException", ()async{

        //arrange
        when(mockFoodRemoteDataSource.getFoodListFromApi("")).thenThrow(ServerTimeoutException());

        //act
        final result = await foodRepositoryWithMock.getFoodListFromApi("");

        //assert
        verify(mockFoodRemoteDataSource.getFoodListFromApi(""));
        expect(result, Left(ServerTimeoutFailure()));
        verifyNoMoreInteractions(mockFoodRemoteDataSource);
      });
    });
  });
  group("test methods from local datasource", ()  {
    final id = 1;
    group("getFoodFromDb()", () {
      test("the wanted product exist", () async{
        //arrange
        when(mockFoodLocalDataSource.getFood(ean)).thenAnswer((_) async => t_FoodModel);

        //act
        final result = await foodRepositoryWithMock.getFoodFromDb(ean);

        //assert
        verify(mockFoodLocalDataSource.getFood(ean));
        expect(result, Right(t_FoodEntity));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("the wanted product doesn't exist", () async {
        //arrange
        when(mockFoodLocalDataSource.getFood(ean)).thenThrow(LocalDatabaseException(message: ""));

        //act
        final result = await foodRepositoryWithMock.getFoodFromDb(ean);

        //assert
        verify(mockFoodLocalDataSource.getFood(ean));
        expect(result, Left(DatabaseFailure()));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });
    });

    group("getFoodListFromDb()", () {
      test("should return a list if there are logs with the given date", () async {
        //arrange
        when(mockFoodLocalDataSource.getFoodList("2022-10-08")).thenAnswer((_) async =>  t_FoodEntityList);

        //act
        final result = await foodRepositoryWithMock.getFoodListFromDb("2022-10-08");

        //assert
        verify(mockFoodLocalDataSource.getFoodList("2022-10-08"));
        expect(result, Right(t_FoodEntityList));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("should return epty list if there no are logs with the given date", () async {
        //arrange
        when(mockFoodLocalDataSource.getFoodList("2022-10-08")).thenThrow(LocalDatabaseException(message: ""));

        //act
        final result = await foodRepositoryWithMock.getFoodListFromDb("2022-10-08");

        result.fold((l) => fail("test failed"), (r) {
          //assert
          verify(mockFoodLocalDataSource.getFoodList("2022-10-08"));
          expect(r, <FoodEntity>[]);
          verifyNoMoreInteractions(mockFoodLocalDataSource);
        });
      });
    });

    group("getMealList()", () {
      test("should return a list if there are logs with the given date", () async {
        //arrange
        when(mockFoodLocalDataSource.getMealList("2022-10-08")).thenAnswer((_) async =>  t_MealEntityList);

        //act
        final result = await foodRepositoryWithMock.getMealList("2022-10-08");

        //assert
        verify(mockFoodLocalDataSource.getMealList("2022-10-08"));
        expect(result, Right(t_MealEntityList));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("should return empty list if there no are logs with the given date", () async {
        //arrange
        when(mockFoodLocalDataSource.getMealList("2022-10-08")).thenThrow(ResultEmptyException());

        //act
        final result = await foodRepositoryWithMock.getMealList("2022-10-08");

        result.fold((l) => fail("test failed"), (r) {
          //assert
          verify(mockFoodLocalDataSource.getMealList("2022-10-08"));
          expect(r, <MealEntity>[]);
          verifyNoMoreInteractions(mockFoodLocalDataSource);
        });
      });
    });

    group("getLog()", () {
      test("should return a log if one is saved with the given id", () async {
        //arrange
        when(mockFoodLocalDataSource.getLog(id))
            .thenAnswer((_) async => t_LogModel);

        //act
        final result = await foodRepositoryWithMock.getLog(id);

        //assert
        verify(mockFoodLocalDataSource.getLog(id));
        expect(result, Right(t_LogModel));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("should return DatabaseFailure if there isn't one saved with the given id", () async {
        //arrange
        when(mockFoodLocalDataSource.getLog(id)).thenThrow(
            LocalDatabaseException(message: ''));

        //act
        final result = await foodRepositoryWithMock.getLog(id);

        //assert
        verify(mockFoodLocalDataSource.getLog(id));
        expect(result, Left(DatabaseFailure()));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });
    });

    group("insertFood()", () {
      test("should return unit if insertion succeeded", () async {
        //arrange
        when(mockFoodLocalDataSource.insertToFoodTable(t_FoodModel))
            .thenAnswer((_) async =>  1);

        //act
        final result = await foodRepositoryWithMock.insertFood(t_FoodEntity);

        //assert
        verify(mockFoodLocalDataSource.insertToFoodTable(t_FoodModel));
        expect(result, Right(unit));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("should return DatabaseFailure if insertion failed", () async {
        //arrange
        when(mockFoodLocalDataSource.insertToFoodTable(t_FoodModel))
            .thenAnswer((_) async =>  0);

        //act
        final result = await foodRepositoryWithMock.insertFood(t_FoodEntity);

        //assert
        verify(mockFoodLocalDataSource.insertToFoodTable(t_FoodModel));
        expect(result, Left(DatabaseFailure()));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });
    });

    group("insertLog()", () {
      test("should return unit if insertion succeeded", () async {
        //arrange
        when(mockFoodLocalDataSource.insertToLogTable(t_LogModel))
            .thenAnswer((_) async =>  1);

        //act
        final result = await foodRepositoryWithMock.insertLog(t_LogModel);

        //assert
        verify(mockFoodLocalDataSource.insertToLogTable(t_LogModel));
        expect(result, Right(unit));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("should return DatabaseFailure if insertion failed", () async {
        //arrange
        when(mockFoodLocalDataSource.insertToLogTable(t_LogModel))
            .thenAnswer((_) async =>  0);

        //act
        final result = await foodRepositoryWithMock.insertLog(t_LogModel);

        //assert
        verify(mockFoodLocalDataSource.insertToLogTable(t_LogModel));
        expect(result, Left(DatabaseFailure()));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });
    });

    group("updateLog()", () {
      test("should return DatabaseFailure if update succeeded", () async {
        //arrange
        when(mockFoodLocalDataSource.updateLogInTable(t_LogModel))
            .thenAnswer((_) async =>  1);

        //act
        final result = await foodRepositoryWithMock.updateLog(t_LogModel);

        //assert
        verify(mockFoodLocalDataSource.updateLogInTable(t_LogModel));
        expect(result, Right(unit));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("should return DatabaseFailure if update failed", () async {
        //arrange
        when(mockFoodLocalDataSource.updateLogInTable(t_LogModel))
            .thenAnswer((_) async =>  0);

        //act
        final result = await foodRepositoryWithMock.updateLog(t_LogModel);

        //assert
        verify(mockFoodLocalDataSource.updateLogInTable(t_LogModel));
        expect(result, Left(DatabaseFailure()));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });
    });

    group("deleteLog()", () {
      test("should return DatabaseFailure if deletion succeeded", () async {
        //arrange
        when(mockFoodLocalDataSource.deleteLogInTable(id))
            .thenAnswer((_) async =>  1);

        //act
        final result = await foodRepositoryWithMock.deleteLog(id);

        //assert
        verify(mockFoodLocalDataSource.deleteLogInTable(id));
        expect(result, Right(unit));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });

      test("should return DatabaseFailure if deletion failed", () async {
        //arrange
        when(mockFoodLocalDataSource.deleteLogInTable(id))
            .thenAnswer((_) async =>  0);

        //act
        final result = await foodRepositoryWithMock.deleteLog(id);

        //assert
        verify(mockFoodLocalDataSource.deleteLogInTable(id));
        expect(result, Left(DatabaseFailure()));
        verifyNoMoreInteractions(mockFoodLocalDataSource);
      });
    });
    
  });
}