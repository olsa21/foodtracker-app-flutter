// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;
import 'package:foodtracker/1presentation/addfood/AddFoodPage.dart' as _i1;
import 'package:foodtracker/1presentation/fooddetail/FoodDetailPage.dart'
    as _i2;
import 'package:foodtracker/1presentation/home/HomePage.dart' as _i3;
import 'package:foodtracker/1presentation/loading/LoadingPage.dart' as _i4;
import 'package:foodtracker/3domain/entitites/FoodEntity.dart' as _i7;
import 'package:foodtracker/3domain/entitites/LogEntity.dart' as _i8;

abstract class $AppRouter extends _i5.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    AddFoodPageRoute.name: (routeData) {
      final args = routeData.argsAs<AddFoodPageRouteArgs>();
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.AddFoodPage(
          key: args.key,
          date: args.date,
        ),
      );
    },
    FoodDetailPageRoute.name: (routeData) {
      final args = routeData.argsAs<FoodDetailPageRouteArgs>();
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.FoodDetailPage(
          key: args.key,
          food: args.food,
          log: args.log,
          date: args.date,
          type: args.type,
        ),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomePage(),
      );
    },
    LoadingPageRoute.name: (routeData) {
      return _i5.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoadingPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddFoodPage]
class AddFoodPageRoute extends _i5.PageRouteInfo<AddFoodPageRouteArgs> {
  AddFoodPageRoute({
    _i6.Key? key,
    required String? date,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          AddFoodPageRoute.name,
          args: AddFoodPageRouteArgs(
            key: key,
            date: date,
          ),
          initialChildren: children,
        );

  static const String name = 'AddFoodPageRoute';

  static const _i5.PageInfo<AddFoodPageRouteArgs> page =
      _i5.PageInfo<AddFoodPageRouteArgs>(name);
}

class AddFoodPageRouteArgs {
  const AddFoodPageRouteArgs({
    this.key,
    required this.date,
  });

  final _i6.Key? key;

  final String? date;

  @override
  String toString() {
    return 'AddFoodPageRouteArgs{key: $key, date: $date}';
  }
}

/// generated route for
/// [_i2.FoodDetailPage]
class FoodDetailPageRoute extends _i5.PageRouteInfo<FoodDetailPageRouteArgs> {
  FoodDetailPageRoute({
    _i6.Key? key,
    required _i7.FoodEntity food,
    _i8.LogEntity? log,
    String? date,
    String? type,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          FoodDetailPageRoute.name,
          args: FoodDetailPageRouteArgs(
            key: key,
            food: food,
            log: log,
            date: date,
            type: type,
          ),
          initialChildren: children,
        );

  static const String name = 'FoodDetailPageRoute';

  static const _i5.PageInfo<FoodDetailPageRouteArgs> page =
      _i5.PageInfo<FoodDetailPageRouteArgs>(name);
}

class FoodDetailPageRouteArgs {
  const FoodDetailPageRouteArgs({
    this.key,
    required this.food,
    this.log,
    this.date,
    this.type,
  });

  final _i6.Key? key;

  final _i7.FoodEntity food;

  final _i8.LogEntity? log;

  final String? date;

  final String? type;

  @override
  String toString() {
    return 'FoodDetailPageRouteArgs{key: $key, food: $food, log: $log, date: $date, type: $type}';
  }
}

/// generated route for
/// [_i3.HomePage]
class HomePageRoute extends _i5.PageRouteInfo<void> {
  const HomePageRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoadingPage]
class LoadingPageRoute extends _i5.PageRouteInfo<void> {
  const LoadingPageRoute({List<_i5.PageRouteInfo>? children})
      : super(
          LoadingPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoadingPageRoute';

  static const _i5.PageInfo<void> page = _i5.PageInfo<void>(name);
}
