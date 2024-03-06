part of 'routes_import.dart';

@AutoRouterConfig(replaceInRouteName: "Route")
class AppRouter extends $AppRouter {

  @override
  RouteType get defaultRouteType => RouteType.material(); //.cupertino, .adaptive ..etc

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomePageRoute.page, initial: true),
    AutoRoute(page: AddFoodPageRoute.page, initial: false),
    AutoRoute(page: FoodDetailPageRoute.page, initial: false),
    AutoRoute(page: LoadingPageRoute.page, initial: false),
  ];
}