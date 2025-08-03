import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../presentation/screen/submission_screen.dart';

class CustomerFeedBackFormController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final jsonString = {
    "formName": "Customer Feedback Form",
    "id": 1,
    "sections": [
      {
        "name": "Personal Information",
        "key": "section_1",
        "fields": [
          {
            "id": 1,
            "key": "text_1",
            "properties": {
              "type": "text",
              "defaultValue": "",
              "hintText": "ex: John Doe",
              "minLength": 2,
              "maxLength": 50,
              "label": "Full Name"
            }
          },
          {
            "id": 1,
            "key": "text_2",
            "properties": {
              "type": "text",
              "defaultValue": "",
              "hintText": "ex: john@example.com",
              "minLength": 5,
              "maxLength": 100,
              "label": "Email Address"
            }
          },
          {
            "id": 2,
            "key": "list_1",
            "properties": {
              "type": "dropDownList",
              "defaultValue": "",
              "hintText": "Select your age group",
              "label": "Age Group",
              "listItems": "[{\"name\":\"Under 18\",\"value\":1},{\"name\":\"18-30\",\"value\":2},{\"name\":\"31-45\",\"value\":3},{\"name\":\"46-60\",\"value\":4},{\"name\":\"Over 60\",\"value\":5}]",
              "multiSelect": false
            }
          }
        ]
      },
      {
        "name": "Feedback Details",
        "key": "section_2",
        "fields": [
          {
            "id": 2,
            "key": "list_2",
            "properties": {
              "type": "checkBoxList",
              "defaultValue": "",
              "hintText": "Select all that apply",
              "label": "What did you like?",
              "listItems": "[{\"name\":\"Product Quality\",\"value\":1},{\"name\":\"Customer Service\",\"value\":2},{\"name\":\"Delivery Speed\",\"value\":3},{\"name\":\"Pricing\",\"value\":4}]",
              "multiSelect": true
            }
          },
          {
            "id": 3,
            "key": "yesno_1",
            "properties": {
              "type": "yesno",
              "defaultValue": "",
              "label": "Would you recommend us?"
            }
          },
          {
            "id": 1,
            "key": "text_3",
            "properties": {
              "type": "text",
              "defaultValue": "",
              "hintText": "ex: The service was great!",
              "minLength": 10,
              "maxLength": 500,
              "label": "Additional Comments"
            }
          },
          {
            "id": 4,
            "key": "image_1",
            "properties": {
              "type": "imageView",
              "defaultValue": "",
              "label": "Upload a photo (optional)",
              "multiImage": false
            }
          }
        ]
      }
    ]
  };
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