import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/customer_form_controller.dart';

class DynamicFormScreen extends StatelessWidget {
  const DynamicFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    final jsonString2 ={
      "formName": "Property Inspection Form",
      "id": 2,
      "sections": [
        {
          "name": "Property Details",
          "key": "section_1",
          "fields": [
            {
              "id": 1,
              "key": "text_1",
              "properties": {
                "type": "text",
                "defaultValue": "",
                "hintText": "ex: 123 Main St",
                "minLength": 5,
                "maxLength": 100,
                "label": "Property Address"
              }
            },
            {
              "id": 2,
              "key": "list_1",
              "properties": {
                "type": "dropDownList",
                "defaultValue": "",
                "hintText": "Select property type",
                "label": "Property Type",
                "listItems": "[{\"name\":\"Apartment\",\"value\":1},{\"name\":\"House\",\"value\":2},{\"name\":\"Commercial\",\"value\":3},{\"name\":\"Land\",\"value\":4}]",
                "multiSelect": false
              }
            },
            {
              "id": 1,
              "key": "text_2",
              "properties": {
                "type": "text",
                "defaultValue": "",
                "hintText": "ex: 1500 sq ft",
                "minLength": 1,
                "maxLength": 20,
                "label": "Area (sq ft)"
              }
            },
            {
              "id": 3,
              "key": "yesno_1",
              "properties": {
                "type": "yesno",
                "defaultValue": "",
                "label": "Is the property furnished?"
              }
            }
          ]
        },
        {
          "name": "Inspection Checklist",
          "key": "section_2",
          "fields": [
            {
              "id": 2,
              "key": "list_2",
              "properties": {
                "type": "checkBoxList",
                "defaultValue": "",
                "hintText": "Select issues found",
                "label": "Defects Found",
                "listItems": "[{\"name\":\"Cracks in Walls\",\"value\":1},{\"name\":\"Leaking Roof\",\"value\":2},{\"name\":\"Faulty Wiring\",\"value\":3},{\"name\":\"Plumbing Issues\",\"value\":4}]",
                "multiSelect": true
              }
            },
            {
              "id": 4,
              "key": "image_1",
              "properties": {
                "type": "imageView",
                "defaultValue": "",
                "label": "Upload photos of defects",
                "multiImage": true
              }
            },
            {
              "id": 1,
              "key": "text_3",
              "properties": {
                "type": "text",
                "defaultValue": "",
                "hintText": "ex: Major structural damage observed",
                "minLength": 0,
                "maxLength": 500,
                "label": "Additional Notes"
              }
            }
          ]
        }
      ]
    } ;
    final jsonString3 = {
      "formName": "Health Survey Form",
      "id": 3,
      "sections": [
        {
          "name": "Basic Information",
          "key": "section_1",
          "fields": [
            {
              "id": 1,
              "key": "text_1",
              "properties": {
                "type": "text",
                "defaultValue": "",
                "hintText": "ex: Alex Smith",
                "minLength": 2,
                "maxLength": 50,
                "label": "Patient Name"
              }
            },
            {
              "id": 2,
              "key": "list_1",
              "properties": {
                "type": "dropDownList",
                "defaultValue": "",
                "hintText": "Select gender",
                "label": "Gender",
                "listItems": "[{\"name\":\"Male\",\"value\":1},{\"name\":\"Female\",\"value\":2},{\"name\":\"Other\",\"value\":3}]",
                "multiSelect": false
              }
            },
            {
              "id": 1,
              "key": "text_2",
              "properties": {
                "type": "text",
                "defaultValue": "",
                "hintText": "ex: 35",
                "minLength": 1,
                "maxLength": 3,
                "label": "Age"
              }
            }
          ]
        },
        {
          "name": "Medical History",
          "key": "section_2",
          "fields": [
            {
              "id": 2,
              "key": "list_2",
              "properties": {
                "type": "checkBoxList",
                "defaultValue": "",
                "hintText": "Select all that apply",
                "label": "Existing Conditions",
                "listItems": "[{\"name\":\"Diabetes\",\"value\":1},{\"name\":\"Hypertension\",\"value\":2},{\"name\":\"Asthma\",\"value\":3},{\"name\":\"Heart Disease\",\"value\":4}]",
                "multiSelect": true
              }
            },
            {
              "id": 3,
              "key": "yesno_1",
              "properties": {
                "type": "yesno",
                "defaultValue": "",
                "label": "Any allergies?"
              }
            },
            {
              "id": 1,
              "key": "text_3",
              "properties": {
                "type": "text",
                "defaultValue": "",
                "hintText": "ex: Peanuts, Penicillin",
                "minLength": 0,
                "maxLength": 200,
                "label": "If yes, specify"
              }
            },
            {
              "id": 4,
              "key": "image_1",
              "properties": {
                "type": "imageView",
                "defaultValue": "",
                "label": "Upload prescription (if any)",
                "multiImage": false
              }
            }
          ]
        }
      ]
    };
    final controller = Get.put(DynamicFormController());
    final formName = jsonString['formName'];
    final sections = jsonString['sections'] as List;

    return Scaffold(
      appBar: AppBar(
          title: Text(formName.toString()),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: sections.map((section) {
              final fields = section['fields'] as List;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...fields.map((field) =>
                      _buildField(field as Map<String, dynamic>, controller)),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.submitForm(sections),
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> field, DynamicFormController controller) {
    final props = field['properties'] as Map<String, dynamic>;
    final key = field['key'];
    final type = props['type'];

    switch (type) {
      case 'text':
        return TextFormField(
          decoration: InputDecoration(
            labelText: props['label'],
            hintText: props['hintText'],
          ),
          validator: (value) {
            if ((value ?? '').isEmpty) return "${props['label']} is required";
            if (props['minLength'] != null &&
                value!.length < props['minLength']) {
              return "${props['label']} must be at least ${props['minLength']} characters";
            }
            if (props['maxLength'] != null &&
                value!.length > props['maxLength']) {
              return "${props['label']} must be less than ${props['maxLength']} characters";
            }
            return null;
          },
          onChanged: (v) => controller.updateValue(key, v),
        );

      case 'dropDownList':
        final items = (jsonDecode(props['listItems']) as List);
        return DropdownButtonFormField(
          decoration: InputDecoration(labelText: props['label']),
          items: items
              .map((e) =>
              DropdownMenuItem(value: e['value'], child: Text(e['name'])))
              .toList(),
          onChanged: (v) => controller.updateValue(key, v),
          validator: (value) => value == null ? "Please select ${props['label']}" : null,
        );

      case 'checkBoxList':
        final items = (jsonDecode(props['listItems']) as List);
        var selected = <dynamic>[].obs;
        controller.updateValue(key, selected);
        return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label'], style: const TextStyle(fontSize: 16)),
            ...items.map((item) => CheckboxListTile(
              value: selected.contains(item['value']),
              title: Text(item['name']),
              onChanged: (val) {
                if (val == true) {
                  selected.add(item['value']);
                } else {
                  selected.remove(item['value']);
                }
                controller.updateValue(key, selected);
              },
            )),
          ],
        ));

      case 'yesno':
        return Obx(() {
          var value = controller.formValues[key] ?? false;
          return SwitchListTile(
            title: Text(props['label']),
            value: value,
            onChanged: (val) => controller.updateValue(key, val),
          );
        });

      case 'imageView':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label']),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  controller.updateValue(key, image.path);
                }
              },
              child: const Text("Upload Image"),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }
}