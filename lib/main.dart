import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:onlinestoredashboard/models/UiO.dart';
import 'package:onlinestoredashboard/pages/calculate/exchange_page.dart';
import 'package:onlinestoredashboard/pages/catalogs/catalog_page.dart';
import 'package:onlinestoredashboard/pages/catalogs/product_page.dart';
import 'package:onlinestoredashboard/pages/home.dart';
import 'package:onlinestoredashboard/pages/organization_page.dart';
import 'package:url_strategy/url_strategy.dart';

import 'controller/Controller.dart';
import 'generated/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: UiO.companyName,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        textTheme: TextTheme(),
        fontFamily: UiO.font,
        // textTheme: TextTheme(bodyText1: ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //primarySwatch: Colors.black87,
      ),
      initialRoute: '/',
      initialBinding: HomeBindings(),
      getPages: [
        GetPage(name: '/cat', page: () => Home()),
        GetPage(name: '/product', page: () => ProductPage()),
        GetPage(name: '/', page: () => CatalogPage()),
        GetPage(name: '/org', page: () => OrganizationPage()),
        GetPage(name: '/exchange', page: () => ExchangePage()),

      ],
    );
  }
}
