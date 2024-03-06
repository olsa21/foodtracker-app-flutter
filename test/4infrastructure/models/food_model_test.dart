import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/4infrastructure/models/FoodModel.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final t_FoodModelCorrect = FoodModel(
    ean: "5053990138722",
    name: "Pringles Original Chips",
    brand: "Pringles",
    imageUrl:
        "https://images.openfoodfacts.org/images/products/505/399/013/8722/front_de.182.400.jpg",
    servingSize: 30.0,
    calories: 533.0,
    fat: 31.0,
    fatSaturated: 2.67,
    carbs: 56.7,
    sugar: 1.33,
    proteins: 6.0,
    salt: 1.1,
    //image: image
  );

  final t_FoodModelFailed = FoodModel(
    ean: "",
    name: "",
    brand: "",
    imageUrl:
    "",
    servingSize: 0,
    //ean: "",
    calories: 0,
    fat: 0,
    //fatNotSatured: fatNotSatured,
    fatSaturated: 0,
    carbs: 0,
    sugar: 0,
    proteins: 0,
    salt: 0,
    //image: image
  );

  final List<FoodEntity> t_FoodListCorrect = [
    FoodModel(
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
    FoodModel(
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
    FoodModel(
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

  test("Model should be subclass of FoodEntity", (){
    //assert
    expect(t_FoodModelCorrect , isA<FoodEntity>());
  });

  group("fromJson factory", (){
    test("should return valid model if JSON is correct", (){
      //arange
      final Map<String, dynamic> jsonMap = json.decode(fixture("food_test_parse.json"));

      //action
      final result = FoodModel.fromJson(jsonMap);

      //assert
      expect(result, t_FoodModelCorrect);
    });

    test("should return valid empty model if JSON is incomplete", (){
      //arange
      final Map<String, dynamic> jsonMap = json.decode(fixture("food_empty.json"));

      //action
      final result = FoodModel.fromJson(jsonMap);

      //assert
      expect(result, t_FoodModelFailed);
    });
  });

  group("fromJsonProduct factory", (){
    test("test parsing JSON-Reply without error", (){
      final Map<String, dynamic> jsonMap = json.decode(fixture("food_search.json"));
      final foodList = <FoodEntity>[];
      List<dynamic> products = jsonMap["products"];

      for (var p in products){
        foodList.add(FoodModel.fromJsonProduct(p));
      }

      expect(foodList, t_FoodListCorrect);
    });
  });

  group("Database factory", (){
    test("test parsing from DB-JSON", (){
      final Map<String, dynamic> jsonMap = json.decode(fixture("food_db_object.json"));
      final food = FoodModel.fromDbJson(jsonMap);

      expect(food, t_FoodModelCorrect);
    });

    test("test parsing to DB-Json", () {
      final Map<String, dynamic> jsonMap1 = json.decode(fixture("food_db_object.json"));
      final jsonMap2 = t_FoodModelCorrect.toDbJson();

      expect(jsonMap1, jsonMap2);
    });
  });
}
