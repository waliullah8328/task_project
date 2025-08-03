import 'package:get/get.dart';


import '../feature/form_list/presentation/screen/form_list_screen.dart';
import '../feature/property_inpection_form/pressentation/screens/property_inpection_form_screen.dart';




class AppRoute {
  static String init = "/";
  static String onboardingScreen= "/onboardingScreen";
  static String loginScreen = "/loginScreen";
  static String propertyInspectionFormScreen = "/propertyInspectionFormScreen";
  static String splashScreen = "/splashScreen";



  static List<GetPage> routes = [

    GetPage(name: init, page: () => FormListPage()),
    GetPage(name: init, page: () => PropertyInpectionFormScreen ()),

   // GetPage(name: init, page: () => WCreatorNavBar()),




    // Worker Flow Screens



  ];
}