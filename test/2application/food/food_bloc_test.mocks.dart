// Mocks generated by Mockito 5.4.4 from annotations
// in foodtracker/test/2application/food/food_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:foodtracker/3domain/entitites/FoodEntity.dart' as _i7;
import 'package:foodtracker/3domain/entitites/LogEntity.dart' as _i8;
import 'package:foodtracker/3domain/entitites/MealEntity.dart' as _i9;
import 'package:foodtracker/3domain/failures/Failures.dart' as _i6;
import 'package:foodtracker/3domain/repositories/FoodRepository.dart' as _i2;
import 'package:foodtracker/3domain/usecases/FoodUseCase.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFoodRepository_0 extends _i1.SmartFake
    implements _i2.FoodRepository {
  _FakeFoodRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FoodUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockFoodUseCase extends _i1.Mock implements _i4.FoodUseCase {
  MockFoodUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FoodRepository get foodRepository => (super.noSuchMethod(
        Invocation.getter(#foodRepository),
        returnValue: _FakeFoodRepository_0(
          this,
          Invocation.getter(#foodRepository),
        ),
      ) as _i2.FoodRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.FoodEntity>> getFoodApiUseCase(
          String? ean) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFoodApiUseCase,
          [ean],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i7.FoodEntity>>.value(
            _FakeEither_1<_i6.Failure, _i7.FoodEntity>(
          this,
          Invocation.method(
            #getFoodApiUseCase,
            [ean],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.FoodEntity>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.FoodEntity>> getFoodLocalUseCase(
          String? ean) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFoodLocalUseCase,
          [ean],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i7.FoodEntity>>.value(
            _FakeEither_1<_i6.Failure, _i7.FoodEntity>(
          this,
          Invocation.method(
            #getFoodLocalUseCase,
            [ean],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.FoodEntity>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i8.LogEntity>> getLogUseCase(int? lId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLogUseCase,
          [lId],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i8.LogEntity>>.value(
            _FakeEither_1<_i6.Failure, _i8.LogEntity>(
          this,
          Invocation.method(
            #getLogUseCase,
            [lId],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i8.LogEntity>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i9.MealEntity>>> getMealListUseCase(
          String? date) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMealListUseCase,
          [date],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, List<_i9.MealEntity>>>.value(
                _FakeEither_1<_i6.Failure, List<_i9.MealEntity>>(
          this,
          Invocation.method(
            #getMealListUseCase,
            [date],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i9.MealEntity>>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.FoodEntity>>>
      getFoodListLocalUseCase(String? date) => (super.noSuchMethod(
            Invocation.method(
              #getFoodListLocalUseCase,
              [date],
            ),
            returnValue:
                _i5.Future<_i3.Either<_i6.Failure, List<_i7.FoodEntity>>>.value(
                    _FakeEither_1<_i6.Failure, List<_i7.FoodEntity>>(
              this,
              Invocation.method(
                #getFoodListLocalUseCase,
                [date],
              ),
            )),
          ) as _i5.Future<_i3.Either<_i6.Failure, List<_i7.FoodEntity>>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.FoodEntity>>>
      getFoodListApiUseCase(String? searchName) => (super.noSuchMethod(
            Invocation.method(
              #getFoodListApiUseCase,
              [searchName],
            ),
            returnValue:
                _i5.Future<_i3.Either<_i6.Failure, List<_i7.FoodEntity>>>.value(
                    _FakeEither_1<_i6.Failure, List<_i7.FoodEntity>>(
              this,
              Invocation.method(
                #getFoodListApiUseCase,
                [searchName],
              ),
            )),
          ) as _i5.Future<_i3.Either<_i6.Failure, List<_i7.FoodEntity>>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>> insertFoodUseCase(
          _i7.FoodEntity? foodEntity) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertFoodUseCase,
          [foodEntity],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>.value(
            _FakeEither_1<_i6.Failure, _i3.Unit>(
          this,
          Invocation.method(
            #insertFoodUseCase,
            [foodEntity],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>> updateLogUseCase(
          _i8.LogEntity? logEntity) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateLogUseCase,
          [logEntity],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>.value(
            _FakeEither_1<_i6.Failure, _i3.Unit>(
          this,
          Invocation.method(
            #updateLogUseCase,
            [logEntity],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>> insertLogUseCase(
          _i8.LogEntity? logEntity) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertLogUseCase,
          [logEntity],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>.value(
            _FakeEither_1<_i6.Failure, _i3.Unit>(
          this,
          Invocation.method(
            #insertLogUseCase,
            [logEntity],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>> deleteLogUseCase(int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteLogUseCase,
          [id],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>.value(
            _FakeEither_1<_i6.Failure, _i3.Unit>(
          this,
          Invocation.method(
            #deleteLogUseCase,
            [id],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>);

  @override
  _i5.Future<_i3.Either<_i6.Failure, int>> syncDatabaseUseCase() =>
      (super.noSuchMethod(
        Invocation.method(
          #syncDatabaseUseCase,
          [],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, int>>.value(
            _FakeEither_1<_i6.Failure, int>(
          this,
          Invocation.method(
            #syncDatabaseUseCase,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, int>>);
}
