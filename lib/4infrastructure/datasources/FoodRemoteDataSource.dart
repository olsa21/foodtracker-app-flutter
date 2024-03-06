import 'dart:convert';
import 'dart:io';

import 'package:foodtracker/4infrastructure/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../3domain/entitites/FoodEntity.dart';
import '../models/FoodModel.dart';

abstract class FoodRemoteDataSource {
  ///Search for specific Product with [ean]
  Future<FoodEntity> getFoodFromApi(String ean);

  ///Search Products with [name]
  Future<List<FoodEntity>> getFoodListFromApi(String name);
}

class FoodRemoteDataSourceImpl extends FoodRemoteDataSource {
  final http.Client client;
  final Connectivity connectivity;

  FoodRemoteDataSourceImpl({required this.client, required this.connectivity});

  @override
  Future<FoodEntity> getFoodFromApi(String ean) async {
    //return FoodModel(ean: ean, name: "Milka NEU", brand: "brand", imageUrl: "", servingSize: 30, calories: 10, fat: 10, fatSaturated: 10, carbs: 10, sugar: 10, proteins: 10, salt: 10);
    if (await connectivity.checkConnectivity() == ConnectivityResult.none) {
      throw NoConnectionException();
    }

    final http.Response response;
    try {
      response = await client.get(
          Uri.parse(
              "https://de.openfoodfacts.org/api/v0/product/$ean?fields=brands,product_name,nutriments,image_front_url,serving_size"),
          headers: {
            'Content-Type': 'application/json',
          }).timeout(const Duration(seconds: 3));

    } catch (e) {
      throw ServerTimeoutException();
    }
    if (response.statusCode != 200) throw ServerException();

    final responseBody = json.decode(response.body);

    FoodModel result = FoodModel.fromJson(responseBody);

    if (!await File("${result.imageDirPath}${result.ean}.jpg").exists()) {
      try {
        final http.Response responsePic =
            await http.get(Uri.parse(result.imageUrl));
        final file = File(join(result.imageDirPath, "${result.ean}.jpg"));
        file.writeAsBytesSync(responsePic.bodyBytes);
      } catch (e) {
        print(e.toString());
        //throw ServerTimeoutException();
      }
    }

    return result;
  }

  @override
  Future<List<FoodEntity>> getFoodListFromApi(String name) async {
    if(name.isEmpty)
      throw EmptySearchException();

    if (await connectivity.checkConnectivity() == ConnectivityResult.none) {
      throw NoConnectionException();
    }

    final foodList = <FoodEntity>[];
    final http.Response response;

    try {
      response = await client.get(
          Uri.parse(
              "https://de.openfoodfacts.org/cgi/search.pl?search_terms=$name&search_simple=1&action=process&json=1"),
          headers: {
            'Content-Type': 'application/json',
          }).timeout(const Duration(seconds: 6));
    } catch (e) {
      throw ServerTimeoutException();
    }

    if (response.statusCode != 200) throw ServerException();

    var products = json.decode(response.body)["products"] as List;

    try {
      for (var p in products) {
        foodList.add(FoodModel.fromJsonProduct(p));
      }
    } catch (e) {
      rethrow;
    }
    return foodList;
  }
}
