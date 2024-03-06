import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodtracker/1presentation/routes/routes_import.gr.dart' as r;
import 'package:foodtracker/theme.dart';

import '1presentation/routes/routes_import.dart';
import '2application/food/food_bloc.dart';
import 'package:foodtracker/Injection.dart' as di; // D I
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final _appRouter = r.AppRouter();
  final _appRouter = di.serviceLocator<AppRouter>();

  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //return MaterialApp.router(routeInformationParser: routeInformationParser, routerDelegate: routerDelegate);
    return BlocProvider(
      create: (context) => di.serviceLocator<FoodBloc>(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(),
        title: "Food-Tracker",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        localizationsDelegates: const [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      ),
    );
  }
}
