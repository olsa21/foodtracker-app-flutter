import 'package:equatable/equatable.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';

class FoodModel extends FoodEntity with EquatableMixin {
  FoodModel({
    required String ean,
    required String name,
    required String brand,
    required String imageUrl,
    required double servingSize,
    required double calories,
    required double fat,
    required double fatSaturated,
    required double carbs,
    required double sugar,
    required double proteins,
    required double salt,
  }) : super(
          ean: ean,
          name: name,
          brand: brand,
          imageUrl: imageUrl,
          servingSize: servingSize,
          calories: calories,
          fat: fat,
          fatSaturated: fatSaturated,
          carbs: carbs,
          sugar: sugar,
          proteins: proteins,
          salt: salt,
        );

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

  factory FoodModel.fromDomain(FoodEntity foodEntity) {
    return FoodModel(
        ean: foodEntity.ean,
        name: foodEntity.name,
        brand: foodEntity.brand,
        imageUrl: foodEntity.imageUrl,
        servingSize: foodEntity.servingSize,
        calories: foodEntity.calories,
        fat: foodEntity.fat,
        fatSaturated: foodEntity.fatSaturated,
        carbs: foodEntity.carbs,
        sugar: foodEntity.sugar,
        proteins: foodEntity.proteins,
        salt: foodEntity.salt);
  }

  ///Convert String to double. With default value 0
  static double _toDouble(dynamic number) {
    print("====> $number");
    if (number == null || number == "null") {
      number = "0";
    }

    String numberStr = number.toString();
    number = "";
    for (int i = 0; i < numberStr.length; i++) {
      if (numberStr[i] == "." ||
          numberStr[i] == "," ||
          numberStr[i] == "0" ||
          numberStr[i] == "1" ||
          numberStr[i] == "2" ||
          numberStr[i] == "3" ||
          numberStr[i] == "4" ||
          numberStr[i] == "5" ||
          numberStr[i] == "6" ||
          numberStr[i] == "7" ||
          numberStr[i] == "8" ||
          numberStr[i] == "9") {
        number += numberStr[i];
      } else {
        break;
      }
    }

    //return double.parse((number ?? "0").toString().replaceAll(RegExp("[a-zA-z]"), "").replaceAll(",", "."));
    return double.parse((number).toString().replaceAll(",", "."));
  }

  ///for JSON-Object from the EAN-search
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
        ean: json["code"] ?? "",
        name: json["product"]["product_name"] ?? "",
        brand: json["product"]["brands"] ?? "",
        imageUrl: json["product"]["image_front_url"] ?? "",
        servingSize: _toDouble(json["product"]["serving_size"]),
        calories: _toDouble(json["product"]["nutriments"]["energy-kcal_100g"]),
        fat: _toDouble(json["product"]["nutriments"]["fat_100g"]),
        fatSaturated:
            _toDouble(json["product"]["nutriments"]["saturated-fat_100g"]),
        carbs: _toDouble(json["product"]["nutriments"]["carbohydrates_100g"]),
        sugar: _toDouble(json["product"]["nutriments"]["sugars_100g"]),
        proteins: _toDouble(json["product"]["nutriments"]["proteins_100g"]),
        salt: _toDouble(json["product"]["nutriments"]["salt_100g"]));
  }

  ///for product JSON-Objects from the search
  factory FoodModel.fromJsonProduct(Map<String, dynamic> json) {
    return FoodModel(
        ean: json["code"] ?? "",
        name: json["product_name"] ?? "",
        brand: json["brands"] ?? "",
        imageUrl: json["image_front_url"] ?? "",
        servingSize: _toDouble(json["serving_size"]),
        calories: _toDouble(json["nutriments"]["energy-kcal_100g"]),
        fat: _toDouble(json["nutriments"]["fat_100g"]),
        fatSaturated: _toDouble(json["nutriments"]["saturated-fat_100g"]),
        carbs: _toDouble(json["nutriments"]["carbohydrates_100g"]),
        sugar: _toDouble(json["nutriments"]["sugars_100g"]),
        proteins: _toDouble(json["nutriments"]["proteins_100g"]),
        salt: _toDouble(json["nutriments"]["salt_100g"]));
  }

  Map<String, dynamic> toDbJson() {
    return {
      'f_ean': ean,
      'f_brand': brand,
      'f_name': name,
      'f_energy': calories,
      'f_fat': fat,
      'f_fat_saturated': fatSaturated,
      'f_carbohydrates': carbs,
      'f_sugar': sugar,
      'f_proteins': proteins,
      'f_salt': salt,
      'f_serving_size': servingSize,
      'f_image_url': imageUrl,
      'f_image': null
    };
  }

  factory FoodModel.fromDbJson(Map<String, dynamic> map) {
    return FoodModel(
      ean: map['f_ean'].toString(),
      name: map['f_name'] as String,
      brand: map['f_brand'] as String,
      imageUrl: map['f_image_url'] as String,
      servingSize: map['f_serving_size'] as double,
      calories: map['f_energy'] as double,
      fat: map['f_fat'] as double,
      fatSaturated: map['f_fat_saturated'] as double,
      carbs: map['f_carbohydrates'] as double,
      sugar: map['f_sugar'] as double,
      proteins: map['f_proteins'] as double,
      salt: map['f_salt'] as double,
    );
  }

  factory FoodModel.empty() {
    return FoodModel(
        ean: "",
        name: "",
        brand: "",
        imageUrl: "",
        servingSize: 0,
        //ean: "",
        calories: 0,
        fat: 0,
        fatSaturated: 0,
        carbs: 0,
        sugar: 0,
        proteins: 0,
        salt: 0);
  }
}
