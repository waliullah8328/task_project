

import 'package:get/get.dart';

import '../../feature/customer_feed_back_form/controller/customer_form_controller.dart';
import '../../feature/health_survey_form/controller/health_survey_controller.dart';
import '../../feature/property_inpection_form/controller/property_inpection_form_controller.dart';



class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerFeedBackFormController >(
          () => CustomerFeedBackFormController (),
      fenix: true,
    );
    Get.lazyPut<PropertyInspectionController  >(
          () => PropertyInspectionController  (),
      fenix: true,
    );
    Get.lazyPut<HealthSurveyController  >(
          () => HealthSurveyController  (),
      fenix: true,
    );



  }
}