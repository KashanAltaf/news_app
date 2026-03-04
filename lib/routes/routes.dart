import 'package:news_app/routes/routes_names.dart';
import 'package:get/get.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/home_screen.dart';
import 'package:news_app/view/news_detail_screen.dart';

import '../view/splash_screen.dart';

class AppRoutes{
  static appRoutes () => [
    GetPage(
      name: RoutesName.splashScreen,
      page: () => SplashScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
      ),
    GetPage(
      name: RoutesName.homeScreen,
      page: () => HomeScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.categoriesScreen,
      page: () => CategoriesScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
    ),
    GetPage(
      name: RoutesName.newsDetailScreen,
      page: () => NewsDetailScreen(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(milliseconds: 250),
    ),
  ];
}