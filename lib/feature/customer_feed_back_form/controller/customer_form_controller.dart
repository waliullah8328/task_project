import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../presentation/screen/submission_screen.dart';

class DynamicFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var formValues = <String, dynamic>{}.obs;

  void updateValue(String key, dynamic value) {
    formValues[key] = value;
  }

  bool validateForm() => formKey.currentState?.validate() ?? false;



  void submitForm(List sections) {
    if (validateForm()) {
      Get.to(() => SubmissionViewPage(
        formData: formValues,
        sections: sections,
      ));
    } else {
      Get.snackbar("Error", "Please fix errors before submitting");
    }
  }
}