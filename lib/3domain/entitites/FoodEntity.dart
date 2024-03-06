import 'package:equatable/equatable.dart';

class FoodEntity with EquatableMixin {
  String imageDirPath = "/data/user/0/com.example.foodtracker/app_flutter/";
  final String ean;
  final String name;
  final String brand;
  final String imageUrl;
  final double servingSize;
  final double calories;
  final double fat;
  final double fatSaturated;
  final double carbs;
  final double sugar;
  final double proteins;
  final double salt;

  @override
  List<Object?> get props => [
        ean,
        name,
        brand,
        imageUrl,
        servingSize,
        calories,
        fat,
        fatSaturated,
        carbs,
        sugar,
        proteins,
        salt
      ];

  FoodEntity({
    required this.ean,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.servingSize,
    required this.calories,
    required this.fat,
    required this.fatSaturated,
    required this.carbs,
    required this.sugar,
    required this.proteins,
    required this.salt,
  });

  factory FoodEntity.empty() {
    return FoodEntity(
        ean: "",
        name: "",
        brand: "",
        imageUrl: "",
        servingSize: 0,
        //ean: "0",
        calories: 0,
        fat: 0,
        fatSaturated: 0,
        carbs: 0,
        sugar: 0,
        proteins: 0,
        salt: 0);
  }

  FoodEntity copyWith({
    String? ean,
    String? name,
    String? brand,
    String? imageUrl,
    double? servingSize,
    double? calories,
    double? fat,
    double? fatSaturated,
    double? carbs,
    double? sugar,
    double? proteins,
    double? salt,
  }) {
    return FoodEntity(
      ean: ean ?? this.ean,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      servingSize: servingSize ?? this.servingSize,
      calories: calories ?? this.calories,
      fat: fat ?? this.fat,
      fatSaturated: fatSaturated ?? this.fatSaturated,
      carbs: carbs ?? this.carbs,
      sugar: sugar ?? this.sugar,
      proteins: proteins ?? this.proteins,
      salt: salt ?? this.salt,
    );
  }
}
