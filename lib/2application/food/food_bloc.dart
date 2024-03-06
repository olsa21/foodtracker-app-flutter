
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/3domain/entitites/LogEntity.dart';
import 'package:foodtracker/3domain/usecases/FoodUseCase.dart';
import 'package:meta/meta.dart';

import '../../3domain/entitites/MealEntity.dart';
import '../../3domain/failures/Failures.dart';
import '../../4infrastructure/models/FoodModel.dart';
import '../../4infrastructure/models/LogModel.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodUseCase usecase;

  final t_FoodEntitiy = FoodEntity(
    ean: "123",
    name: "Pringles Original Chips",
    brand: "Pringles",
    imageUrl:
    "https://images.openfoodfacts.org/images/products/505/399/013/8722/front_de.182.400.jpg",
    servingSize: 30,
    calories: 533,
    fat: 31,
    fatSaturated: 2.67,
    carbs: 56.7,
    sugar: 1.33,
    proteins: 6,
    salt: 1.1,
  );

  final t_MealList = <MealEntity>[MealEntity(food: FoodModel.empty(), log: LogModel.empty()),MealEntity(food: FoodModel.empty(), log: LogModel.empty())];

  FoodBloc({required this.usecase}) : super(FoodInitial()) {
    on<FoodRequestedEvent>((event, emit) async {
      print("entered bloc FoodRequestedEvent");
      emit(FoodStateLoading());

      //await Future.delayed(Duration(seconds: 3));

      Either<Failure,FoodEntity> localFoodOrFailure = await usecase.getFoodLocalUseCase(event.ean);

      if(localFoodOrFailure.isRight()){
        localFoodOrFailure.fold((failure) => null, (food) {
          emit(FoodStateFoodLoaded(foodEntity: food));
        });
      }
      else{
        Either<Failure,FoodEntity> foodOrFailure = await usecase.getFoodApiUseCase(event.ean);
        foodOrFailure.fold((failure) => emit(FoodStateError(message: _mapFailureToMessage(failure))), (food) { emit(FoodStateFoodLoaded(foodEntity: food));});
      }
    });

    on<InsertFoodEvent>((event, emit) async {
      print("entered bloc InsertFoodEvent");

      Either<Failure, Unit> unitOrFailure1 = await usecase.insertFoodUseCase(event.foodEntity);
      Either<Failure, Unit> unitOrFailure2 = await usecase.insertLogUseCase(event.logEntity);

      if(unitOrFailure1.isLeft() && unitOrFailure2.isLeft()){
        unitOrFailure1.leftMap((failure) => emit(FoodStateError(message: _mapFailureToMessage(failure))));
      }

      emit(SuccessState());
      //emit(FoodStateLoaded(foodEntity: t_FoodEntitiy));
    });

    on<UpdateFoodLogEvent>((event, emit) async {
      print("entered bloc UpdateFoodLogEvent");

      Either<Failure, Unit> unitOrFailure = await usecase.updateLogUseCase(event.logEntity);

      unitOrFailure.fold((failure) => emit(FoodStateError(message: _mapFailureToMessage(failure))), (unit) => emit(SuccessState()));
    });

    on<DeleteLogEvent>((event, emit) async {
      print("entered DELETE bloc DeleteLogEvent");

      Either<Failure, Unit> unitOrFailure = await usecase.deleteLogUseCase(event.id);

      unitOrFailure.fold((failure) => emit(FoodStateError(message: _mapFailureToMessage(failure))), (unit) => emit(SuccessState()));
    });

    on<LocalFoodListRequestedEvent>((event, emit) async {
      print("entered bloc LocalFoodListRequestedEvent");

      Either<Failure,List<FoodEntity>> foodOrFailure = await usecase.getFoodListLocalUseCase(event.date);

      foodOrFailure.fold(
          (failure) => {
                emit(FoodStateError(message: _mapFailureToMessage(failure))),
                print("Failure at Database")
              }, (foodList) {
        emit(FoodStateFoodListLoaded(foodEntityList: foodList));
      });
    });

    on<MealListRequestedEvent>((event, emit) async {
      print("entered bloc MealListRequestedEvent");
      Either<Failure,List<MealEntity>> mealOrFailure = await usecase.getMealListUseCase(event.date);

      //3.
      mealOrFailure.fold(
          (failure) => {
                emit(FoodStateError(message: _mapFailureToMessage(failure))),
                print("Failure at Database")
              }, (mealList) async {
        emit(FoodStateMealListLoaded(mealEntityList: mealList));
      });
      //await Future.delayed(Duration(milliseconds: 10));
      //emit(FoodInitial());
      //emit(FoodStateLoaded(foodEntity: t_FoodEntitiy));
    });

    on<RemoteFoodListRequestedEvent>((event, emit) async {
      print("entered RemoteFoodListRequestedEvent Bloc; with Name: ${event.searchName}");
      //1.
      //emit(FoodStateLoading());

      //await Future.delayed(Duration(seconds: 1));

      Either<Failure,List<FoodEntity>> foodOrFailure = await usecase.getFoodListApiUseCase(event.searchName);

      foodOrFailure.fold((failure) => emit(FoodStateError(message: _mapFailureToMessage(failure))), (foodList) { emit(FoodStateRemoteFoodListLoaded(foodEntityList: foodList));});

      //emit(FoodStateRemoteFoodListLoaded(foodEntityList: FoodEntityList().foodList));
    });

    on<SyncDatabaseEvent>((event, emit) async {
      emit(FoodStateLoading());

      //await Future.delayed(Duration(seconds: 3));
      Either<Failure,int> intOrFailure = await usecase.syncDatabaseUseCase();

      intOrFailure.fold((failure) => emit(FoodStateError(message: _mapFailureToMessage(failure))), (int) { emit(SuccessState());});

    });
  }

  String _mapFailureToMessage(Failure failure){
    switch (failure.runtimeType){
      case ServerFailure: return "API Error, please try again!";
      case GeneralFailure: return "Something went wrong. Try again!";
      case ServerTimeoutFailure: return "API Timeout, please try again!";
      case NoConnectionFailure: return "No internet connection, please try again!";
      case EmptySearchFailure: return "Empty Query!";
      default: return "Something went wrong. Try again!";
    }
  }
}