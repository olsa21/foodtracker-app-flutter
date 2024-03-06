import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodtracker/2application/food/food_bloc.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';
import 'package:foodtracker/3domain/entitites/MealEntity.dart';
import 'package:foodtracker/3domain/failures/Failures.dart';
import 'package:foodtracker/3domain/usecases/FoodUseCase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_bloc_test.mocks.dart';

const GENERAL_FAILURE_MESSAGE = "Something went wrong. Try again!";
const SERVER_FAILURE_MESSAGE = "API Error, please try again!";

@GenerateMocks([FoodUseCase])
void main(){
  late FoodBloc foodBloc;
  late MockFoodUseCase mockFoodUseCase;

  setUp((){
    mockFoodUseCase = MockFoodUseCase();
    foodBloc = FoodBloc(usecase: mockFoodUseCase);
  });

  test("test if state is initally FoodInitial", () {
    //assert
    expect(foodBloc.state, equals(FoodInitial()));
  });

  const String ean ="123";
  final t_FoodEntity = FoodEntity(
    ean: ean,
    name: "Pringles Original Chips",
    brand: "Pringles",
    imageUrl:
    "https://images.openfoodfacts.org/images/products/505/399/013/8722/front_de.182.400.jpg",
    servingSize: 30,
    //ean: "5053990138722",
    calories: 533,
    fat: 31,
    //fatNotSatured: fatNotSatured,
    fatSaturated: 2.67,
    carbs: 56.7,
    sugar: 1.33,
    proteins: 6,
    salt: 1.1,
    //image: image
  );

  final t_LogEntity = LogEntity(id: null, ean: "123", amount: 100, date: null, type: "Breakfast");
  final List<FoodEntity> t_FoodEntityList = [t_FoodEntity, t_FoodEntity];

  group("FoodRequestedEvent()", () {
    test("should call UseCase if event is triggered", () async {
      //arrange
      when(mockFoodUseCase.getFoodLocalUseCase(ean))
          .thenAnswer((_) async => Right(t_FoodEntity));

      //act
      foodBloc.add(FoodRequestedEvent(ean: ean));
      await untilCalled(mockFoodUseCase.getFoodLocalUseCase(ean));

      //assert
      verify(mockFoodUseCase.getFoodLocalUseCase(ean));
      verifyNoMoreInteractions(mockFoodUseCase);
    });

    test(
        "should emit FoodStateLoading() then FoodStateLoaded() with valid food after event is triggered",
            () {
          //arrange
          when(mockFoodUseCase.getFoodLocalUseCase(ean))
              .thenAnswer((_) async => Right(t_FoodEntity));

          //assert later
          final expectedReturnedStateList = [
            FoodStateLoading(),
            FoodStateFoodLoaded(foodEntity: t_FoodEntity)
          ];

          expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

          //act
          foodBloc.add(FoodRequestedEvent(ean: ean));

        });

    test(
        "should emit FoodStateLoading() then FoodStateError() after event is triggered -> local UseCase fails -> remote UseCase fails -> ServerFailure",
            () {
          //arrange
          when(mockFoodUseCase.getFoodLocalUseCase(ean))
              .thenAnswer((_) async => Left(GeneralFailure()));

          when(mockFoodUseCase.getFoodApiUseCase(ean))
              .thenAnswer((_) async => Left(ServerFailure()));

          //assert later
          final expectedReturnedStateList = [
            FoodStateLoading(),
            FoodStateError(message: SERVER_FAILURE_MESSAGE)
          ];

          expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

          //act
          foodBloc.add(FoodRequestedEvent(ean: ean));

          //assert
        });

    test(
        "should emit FoodStateLoading() then FoodStateError() after event is triggered -> local UseCase fails -> remote UseCase works -> FoodStateFoodLoaded",
            () {
          //arrange
          when(mockFoodUseCase.getFoodLocalUseCase(ean))
              .thenAnswer((_) async => Left(GeneralFailure()));

          when(mockFoodUseCase.getFoodApiUseCase(ean))
              .thenAnswer((_) async => Right(t_FoodEntity));

          //assert later
          final expectedReturnedStateList = [
            FoodStateLoading(),
            FoodStateFoodLoaded(foodEntity: t_FoodEntity)
          ];

          expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

          //act
          foodBloc.add(FoodRequestedEvent(ean: ean));

          //assert
        });

    test(
        "should emit FoodStateLoading() then FoodStateError() after event is triggered -> local UseCase fails -> remote UseCase fails ->  GeneralFailure",
            () {
          //arrange
          when(mockFoodUseCase.getFoodLocalUseCase(ean))
                  .thenAnswer((_) async => Left(GeneralFailure()));
          when(mockFoodUseCase.getFoodApiUseCase(ean))
              .thenAnswer((_) async => Left(GeneralFailure()));

          //assert later
          final expectedReturnedStateList = [
            FoodStateLoading(),
            FoodStateError(message: GENERAL_FAILURE_MESSAGE)
          ];

          expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

          //act
          foodBloc.add(FoodRequestedEvent(ean: ean));

        });
  });

  group("InsertFoodEvent()", (){
    test("should call insertFoodUseCase and intertLogUseCase if event triggered", () async {
      //arrange
      when(mockFoodUseCase.insertFoodUseCase(any))
          .thenAnswer((_) async => Right(unit));
      when(mockFoodUseCase.insertLogUseCase(any))
          .thenAnswer((_) async => Right(unit));

      //act
      foodBloc.add(InsertFoodEvent(foodEntity: t_FoodEntity, logEntity: t_LogEntity));
      await untilCalled(mockFoodUseCase.insertFoodUseCase(t_FoodEntity));
      await untilCalled(mockFoodUseCase.insertLogUseCase(t_LogEntity));

      //assert
      verify(mockFoodUseCase.insertFoodUseCase(t_FoodEntity));
      verify(mockFoodUseCase.insertLogUseCase(t_LogEntity));
      verifyNoMoreInteractions(mockFoodUseCase);
    });

    test("should emit SuccessState if log and food inserted successfully", (){
      //arrange
      when(mockFoodUseCase.insertFoodUseCase(t_FoodEntity))
          .thenAnswer((_) async => Right(unit));
      when(mockFoodUseCase.insertLogUseCase(t_LogEntity))
          .thenAnswer((_) async => Right(unit));

      //assert later
      final expectedReturnedStateList = [
        SuccessState()
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(InsertFoodEvent(foodEntity: t_FoodEntity, logEntity: t_LogEntity));
    });

    test("should emit FoodStateError if log or food fails", (){
      //arrange
      when(mockFoodUseCase.insertFoodUseCase(t_FoodEntity))
          .thenAnswer((_) async => Left(GeneralFailure()));
      when(mockFoodUseCase.insertLogUseCase(t_LogEntity))
          .thenAnswer((_) async => Left(GeneralFailure()));

      //assert later
      final expectedReturnedStateList = [
        FoodStateError(message: GENERAL_FAILURE_MESSAGE)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(InsertFoodEvent(foodEntity: t_FoodEntity, logEntity: t_LogEntity));
    });
  });

  group("UpdateFoodLogEvent()", (){
    test("should emit SuccessState if log and food update succeeded", (){
      //arrange
      when(mockFoodUseCase.updateLogUseCase(any))
          .thenAnswer((_) async => Right(unit));

      //assert later
      final expectedReturnedStateList = [
        SuccessState()
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(UpdateFoodLogEvent(logEntity: t_LogEntity));
    });

    test("should emit FoodStateError if log and food update failed", (){
      //arrange
      when(mockFoodUseCase.updateLogUseCase(any))
          .thenAnswer((_) async => Left(GeneralFailure()));

      //assert later
      final expectedReturnedStateList = [
        FoodStateError(message: GENERAL_FAILURE_MESSAGE)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(UpdateFoodLogEvent(logEntity: t_LogEntity));
    });
  });

  group("DeleteLogEvent()", (){
    test("should emit SuccessState if log deletion succeeded", (){
      //arrange
      when(mockFoodUseCase.deleteLogUseCase(any))
          .thenAnswer((_) async => Right(unit));

      //assert later
      final expectedReturnedStateList = [
        SuccessState()
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(DeleteLogEvent(id: 1));
    });

    test("should emit FoodStateError if log deletion failed", (){
      //arrange
      when(mockFoodUseCase.deleteLogUseCase(any))
          .thenAnswer((_) async => Left(GeneralFailure()));

      //assert later
      final expectedReturnedStateList = [
        FoodStateError(message: GENERAL_FAILURE_MESSAGE)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(DeleteLogEvent(id: 1));
    });
  });

  group("LocalFoodListRequestedEvent()", (){
    test("should emit FoodStateFoodListLoaded if request succeeded", (){
      //arrange
      when(mockFoodUseCase.getFoodListLocalUseCase(any))
          .thenAnswer((_) async => Right(t_FoodEntityList));

      //assert later
      final expectedReturnedStateList = [
        FoodStateFoodListLoaded(foodEntityList: t_FoodEntityList)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(LocalFoodListRequestedEvent(date: '2022-10-06'));
    });

    test("should emit FoodStateError if request failed", (){
      //arrange
      when(mockFoodUseCase.getFoodListLocalUseCase(any))
          .thenAnswer((_) async => Left(GeneralFailure()));

      //assert later
      final expectedReturnedStateList = [
        FoodStateError(message: GENERAL_FAILURE_MESSAGE)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(LocalFoodListRequestedEvent(date: '2022-10-06'));
    });
  });

  group("MealListRequestedEvent()", (){
    List<MealEntity> t_mealEntityList = [];
    test("should emit FoodStateMealListLoaded if request succeeded", (){
      //arrange
      when(mockFoodUseCase.getMealListUseCase(any))
          .thenAnswer((_) async => Right(t_mealEntityList));

      //assert later
      final expectedReturnedStateList = [
        FoodStateMealListLoaded(mealEntityList: t_mealEntityList)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(MealListRequestedEvent(date: '2022-10-06'));
    });

    test("should emit FoodStateError if request failed", (){
      //arrange
      when(mockFoodUseCase.getMealListUseCase(any))
          .thenAnswer((_) async => Left(GeneralFailure()));

      //assert later
      final expectedReturnedStateList = [
        FoodStateError(message: GENERAL_FAILURE_MESSAGE)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(MealListRequestedEvent(date: '2022-10-06'));
    });
  });

  group("RemoteFoodListRequestedEvent()", (){
    test("should emit FoodStateLoading and FoodStateRemoteFoodListLoaded if request succeeded", (){
      //arrange
      when(mockFoodUseCase.getFoodListApiUseCase("name"))
          .thenAnswer((_) async => Right(t_FoodEntityList));

      //assert later
      final expectedReturnedStateList = [
        FoodStateLoading(),
        FoodStateRemoteFoodListLoaded(foodEntityList: t_FoodEntityList)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(RemoteFoodListRequestedEvent(searchName: "name"));
    });

    test("should emit FoodStateLoading and FoodStateError if request failed", (){
      //arrange
      when(mockFoodUseCase.getFoodListApiUseCase("name"))
          .thenAnswer((_) async => Left(GeneralFailure()));

      //assert later
      final expectedReturnedStateList = [
        FoodStateLoading(),
        FoodStateError(message: GENERAL_FAILURE_MESSAGE)
      ];

      expectLater(foodBloc.stream, emitsInOrder(expectedReturnedStateList));

      //act
      foodBloc.add(RemoteFoodListRequestedEvent(searchName: "name"));
    });
  });
}