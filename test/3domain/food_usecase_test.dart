
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/failures/Failures.dart';
import 'package:foodtracker/3domain/repositories/FoodRepository.dart';
import 'package:foodtracker/3domain/usecases/FoodUseCase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'food_usecase_test.mocks.dart';

@GenerateMocks([FoodRepository])
void main(){
  late FoodUseCase foodUseCase;
  late MockFoodRepository mockFoodRepository;

  setUp((){
    mockFoodRepository = MockFoodRepository();
    foodUseCase = FoodUseCase(foodRepository: mockFoodRepository);
  });



  group("getFoodUseCase", (){
    const String ean = "123";
    final t_FoodEntitiy = FoodEntity(
      name: "Pringles Original Chips",
      brand: "Pringles",
      imageUrl:
      "https://images.openfoodfacts.org/images/products/505/399/013/8722/front_de.182.400.jpg",
      servingSize: 30,
      ean: ean,
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

    test("should return the same food as repo", () async {
      //arange
      when(mockFoodRepository.getFoodFromApi(ean))
          .thenAnswer((_) async => Right(t_FoodEntitiy));

      //action
      //foodUseCase.ean="123";
      final result = await foodUseCase.getFoodApiUseCase(ean);

      //assert
      expect(result, Right(t_FoodEntitiy));
      verify(mockFoodRepository.getFoodFromApi(ean));
      verifyNoMoreInteractions(mockFoodRepository);

    });

    test("should return the same failure as repo (ServerFailure)", () async {
      // arrange
      when(mockFoodRepository.getFoodFromApi(ean))
          .thenAnswer((_) async => Left(ServerFailure()));

      // act
      final result = await foodUseCase.getFoodApiUseCase(ean);

      // assert
      expect(result, Left(ServerFailure()));
      verify(mockFoodRepository.getFoodFromApi(ean));
      verifyNoMoreInteractions(mockFoodRepository);
    });

    test("should return the same failure as repo (GeneralFailure)", () async {
      // arrange
      when(mockFoodRepository.getFoodFromApi(ean))
          .thenAnswer((_) async => Left(GeneralFailure()));

      // act
      final result = await foodUseCase.getFoodApiUseCase(ean);

      // assert
      expect(result, Left(GeneralFailure()));
      verify(mockFoodRepository.getFoodFromApi(ean));
      verifyNoMoreInteractions(mockFoodRepository);
    });
  });
}