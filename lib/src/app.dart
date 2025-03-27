import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location_tracker/src/pages/recycle_view_locations.dart';
import 'package:location_tracker/src/pages/add_location.dart';
import 'package:location_tracker/src/pages/edit_location.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), 
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      theme: ThemeData(
      primaryColor: const Color(0xFFFFF8E1), 
      scaffoldBackgroundColor: const Color(0xFFFFF8E1), 
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFE8DDB5), 
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87), 
          bodyMedium: TextStyle(color: Colors.black87), 
          bodySmall: TextStyle(color: Colors.black54), 
        ),
      ),
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case AddLocation.routeName:
                return AddLocation();
              case EditLocation.routeName:
                return EditLocation();
              case RecycleViewLocations.routeName:
                return RecycleViewLocations();
              default:
                return const RecycleViewLocations();
            }
          },
        );
      },
    );
  }
}
