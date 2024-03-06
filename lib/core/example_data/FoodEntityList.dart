import '../../3domain/entitites/FoodEntity.dart';

class FoodEntityList{
   List<FoodEntity> foodList = [
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
}