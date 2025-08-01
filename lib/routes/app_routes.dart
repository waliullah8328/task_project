import 'package:get/get.dart';
import 'package:task_project/feature/form_list/data/screen/form_list_screen.dart';




class AppRoute {
  static String init = "/";
  static String onboardingScreen= "/onboardingScreen";
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String splashScreen = "/splashScreen";



  static List<GetPage> routes = [

    GetPage(name: init, page: () => FormListPage()),

   // GetPage(name: init, page: () => WCreatorNavBar()),




    // Worker Flow Screens



  ];
}