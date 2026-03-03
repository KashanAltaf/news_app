import 'package:news_app/routes/routes_names.dart';
import 'package:get/get.dart';
import 'package:news_app/view/home_screen.dart';

import '../view/splash_screen.dart';

class AppRoutes{
  static appRoutes () => [
    GetPage(
      name: RoutesName.splashScreen,
      page: () => SplashScreen(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 250),
      ),
    GetPage(
      name: RoutesName.homeScreen,
      page: () => HomeScreen(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 250),
    ),
  ];
}