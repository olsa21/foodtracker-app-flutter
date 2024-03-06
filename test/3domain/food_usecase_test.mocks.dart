// Mocks generated by Mockito 5.4.4 from annotations
// in foodtracker/test/3domain/food_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:foodtracker/3domain/entitites/FoodEntity.dart' as _i6;
import 'package:foodtracker/3domain/entitites/LogEntity.dart' as _i8;
import 'package:foodtracker/3domain/entitites/MealEntity.dart' as _i7;
import 'package:foodtracker/3domain/failures/Failures.dart' as _i5;
import 'package:foodtracker/3domain/repositories/FoodRepository.dart' as _i3;
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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FoodRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockFoodRepository extends _i1.Mock implements _i3.FoodRepository {
  MockFoodRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.FoodEntity>> getFoodFromApi(
          String? ean) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFoodFromApi,
          [ean],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.FoodEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.FoodEntity>(
          this,
          Invocation.method(
            #getFoodFromApi,
            [ean],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.FoodEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.FoodEntity>> getFoodFromDb(
          String? ean) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFoodFromDb,
          [ean],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.FoodEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.FoodEntity>(
          this,
          Invocation.method(
            #getFoodFromDb,
            [ean],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.FoodEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.FoodEntity>>> getFoodListFromApi(
          String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFoodListFromApi,
          [name],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.FoodEntity>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.FoodEntity>>(
          this,
          Invocation.method(
            #getFoodListFromApi,
            [name],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.FoodEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.FoodEntity>>> getFoodListFromDb(
          String? date) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFoodListFromDb,
          [date],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.FoodEntity>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.FoodEntity>>(
          this,
          Invocation.method(
            #getFoodListFromDb,
            [date],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.FoodEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i7.MealEntity>>> getMealList(
          String? date) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMealList,
          [date],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i7.MealEntity>>>.value(
                _FakeEither_0<_i5.Failure, List<_i7.MealEntity>>(
          this,
          Invocation.method(
            #getMealList,
            [date],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i7.MealEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i8.LogEntity>> getLog(int? lId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLog,
          [lId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i8.LogEntity>>.value(
            _FakeEither_0<_i5.Failure, _i8.LogEntity>(
          this,
          Invocation.method(
            #getLog,
            [lId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i8.LogEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> insertFood(
          _i6.FoodEntity? foodEntity) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertFood,
          [foodEntity],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #insertFood,
            [foodEntity],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> insertLog(
          _i8.LogEntity? logEntity) =>
      (super.noSuchMethod(
        Invocation.method(
          #insertLog,
          [logEntity],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #insertLog,
            [logEntity],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> updateLog(
          _i8.LogEntity? logEntity) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateLog,
          [logEntity],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #updateLog,
            [logEntity],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> deleteLog(int? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteLog,
          [id],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #deleteLog,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, int>> syncProuductsDB() =>
      (super.noSuchMethod(
        Invocation.method(
          #syncProuductsDB,
          [],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, int>>.value(
            _FakeEither_0<_i5.Failure, int>(
          this,
          Invocation.method(
            #syncProuductsDB,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, int>>);
}
