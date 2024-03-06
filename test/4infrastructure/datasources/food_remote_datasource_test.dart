import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodtracker/3domain/entitites/FoodEntity.dart';
import 'package:foodtracker/4infrastructure/datasources/FoodRemoteDataSource.dart';
import 'package:foodtracker/4infrastructure/exceptions/exceptions.dart';
import 'package:foodtracker/4infrastructure/models/FoodModel.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../fixtures/fixture_reader.dart';
import 'food_remote_datasource_test.mocks.dart';

@GenerateMocks([http.Client, Connectivity])
void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  late FoodRemoteDataSource foodRemoteDataSource;
  late MockClient mockClient;
  late MockConnectivity mockConnectivity;
  //final String code ="1234567890";

  setUp((){
    mockClient = MockClient();
    mockConnectivity = MockConnectivity();
    foodRemoteDataSource = FoodRemoteDataSourceImpl(client: mockClient, connectivity: mockConnectivity);
  });

  /// Fakes failed HTTP response
  void setUpMockClientFailure() {
    when(mockClient.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response("something went wrong", 404));
  }

  // Fakes an existing internet connection
  void setUpConnectionStatus(){
    when(mockConnectivity.checkConnectivity()).thenAnswer((_) async => ConnectivityResult.wifi);
  }

  group("getFoodFromApi()", () {
    const String ean ="5053990138722";
    final t_FoodModelCorrect = FoodModel(
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

    test("test request timeout", () {
      //arrange
      when(mockClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => Future.delayed(const Duration(seconds: 5), () {
                return http.Response("",0);
              }));
      setUpConnectionStatus();

      //act
      final call = foodRemoteDataSource.getFoodFromApi(ean);

      //assert
      expect(()=> call, throwsA(const TypeMatcher<ServerTimeoutException>()));
      });

    test("test parsing JSON-Reply without error", () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed("headers"))).thenAnswer(
              (_) async => http.Response(fixture("food_test_parse.json"), 200, headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8',
          }));
      setUpConnectionStatus();

      //act
      await foodRemoteDataSource.getFoodFromApi(ean);

      //assert
      verify(mockClient
          .get(Uri.parse("https://de.openfoodfacts.org/api/v0/product/$ean?fields=brands,product_name,nutriments,image_front_url,serving_size"), headers:{
        'Content-Type': 'application/json',
      }));
    });

    test("test if URL is correct and header application/json", () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed("headers"))).thenAnswer(
              (_) async => http.Response(fixture("food.json"), 200, headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8',
          }));
      setUpConnectionStatus();

      //act
      await foodRemoteDataSource.getFoodFromApi(ean);

      //assert
      verify(mockClient
          .get(Uri.parse("https://de.openfoodfacts.org/api/v0/product/$ean?fields=brands,product_name,nutriments,image_front_url,serving_size"), headers:{
        'Content-Type': 'application/json',
      }));
    });

    test("should return a valid food when response is success 200", () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed("headers"))).thenAnswer(
              (_) async => http.Response(fixture("food.json"), 200, headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8',
          }));
      setUpConnectionStatus();

      //act
      final result = await foodRemoteDataSource.getFoodFromApi(ean);

      //assert
      expect(result, t_FoodModelCorrect);
    });

    test("should throw ServerException if Response Code not 200", () {
      //arrange
      setUpMockClientFailure();
      setUpConnectionStatus();

      //act
      final call = foodRemoteDataSource.getFoodFromApi(ean); //Funktion wird gespeichert, unten ausgeführt

      //assert
      expect(()=> call, throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getFoodListFromApi()", (){
    String searchName = "Cola";
    void setUpMockClientSuccess200() {
      when(mockClient.get(any, headers: anyNamed("headers"))).thenAnswer(
              (_) async => http.Response(fixture("food_search.json"), 200, headers: {
                HttpHeaders.contentTypeHeader:
                'application/json; charset=utf-8',
              }));
    }

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

    test("test request timeout", () {
      //arrange
      when(mockClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => Future.delayed(const Duration(seconds: 6), () {
        return http.Response("",0);
      }));
      setUpConnectionStatus();

      //act
      final call = foodRemoteDataSource.getFoodListFromApi("name");

      //assert
      expect(()=> call, throwsA(const TypeMatcher<ServerTimeoutException>()));
    });

    test("test if URL for search is correct and header application/json", () async {
      //arrange
      setUpMockClientSuccess200();
      setUpConnectionStatus();

      //act
      await foodRemoteDataSource.getFoodListFromApi(searchName);

      //assert
      verify(mockClient
          .get(Uri.parse("https://de.openfoodfacts.org/cgi/search.pl?search_terms=$searchName&search_simple=1&action=process&json=1"), headers:{
        'Content-Type': 'application/json',
      }));
    });

    test("should throw ServerException if Response Code not 200", () {
      //arrange
      setUpMockClientFailure();
      setUpConnectionStatus();

      //act
      final call = foodRemoteDataSource.getFoodListFromApi("123456");

      //assert
      expect(()=> call, throwsA(const TypeMatcher<ServerException>()));
    });

    test("shoult return a valid list of Object", () async {
      //arrange
      setUpMockClientSuccess200();
      setUpConnectionStatus();

      //act
      final result = await foodRemoteDataSource.getFoodListFromApi(searchName);

      //assert
      expect(t_FoodListCorrect, result);
    });
  });
}