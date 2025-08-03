import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/app_sizes.dart';
import '../../controller/health_survey_controller.dart';
import 'health_survey_form_preview_page.dart';

class HealthSurveyFormScreen extends StatelessWidget {
  const HealthSurveyFormScreen({super.key});



  @override
  Widget build(BuildContext context) {

    final controller = Get.find<HealthSurveyController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: getHeight(80),
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new)),
        centerTitle: true,
        title: Text(controller.formJson['formName'],style: TextStyle(fontSize: getWidth(22),fontWeight: FontWeight.w500),),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: getWidth(16),right: getWidth(16),top: getHeight(16),bottom: getHeight(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:controller.formJson['sections'].map<Widget>((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section['name'] ?? '',
                    style:  TextStyle(
                        fontSize: getWidth(18), fontWeight: FontWeight.bold)),
                SizedBox(height: getHeight(12)),
                ...section['fields'].map<Widget>((field) {
                  return _buildField(controller, field);
                }).toList(),
                 SizedBox(height: getHeight(20))
              ],
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          child: const Text("Submit"),
          onPressed: () {

            if (controller.validateForm()) {
              Get.to(() => HealthSurveyFormPreviewPage());
            }

          },
        ),
      ),
    );
  }


  Widget _buildField(HealthSurveyController controller, dynamic field) {
    final props = field['properties'];
    final key = field['key'];

    switch (props['type']) {
      case 'text':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label'],style: TextStyle(fontSize: getWidth(15),fontWeight: FontWeight.w600),),
            SizedBox(height: getHeight(16),),
            TextField(
              decoration: InputDecoration(
                  hintText: props['hintText'],hintStyle: TextStyle(color: Colors.grey)),
              onChanged: (v) => controller.setValue(key, v),
            ),
          ],
        );

      case 'dropDownList':
        final items = (jsonDecode(props['listItems']) as List)
            .map((e) => DropdownMenuItem<String>(
          value: e['name'],
          child: Text(e['name']),
        ))
            .toList();

        return Obx(() {
          // Get current selected value, default null
          final selectedValue = controller.formData[key] is Rx<String>
              ? (controller.formData[key] as Rx<String>).value
              : null;
          return Padding(
            padding:  EdgeInsets.only(top: getHeight(16),bottom: getWidth(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(props['label'],style: TextStyle(fontSize: getWidth(15),fontWeight: FontWeight.w600),),
                SizedBox(height: getHeight(16),),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(hintText: props['hintText']),
                  items: items,
                  value: selectedValue == '' ? null : selectedValue,
                  onChanged: (val) => controller.setValue(key, val ?? ''),
                ),
              ],
            ),
          );
        });

      case 'yesno':
        return Obx(() {
          final val = controller.formData[key] is Rx<String>
              ? (controller.formData[key] as Rx<String>).value
              : 'No';
          return Padding(
            padding:  EdgeInsets.only(top: getHeight(16),bottom: getWidth(16)),
            child: SwitchListTile(
              title: Text(props['label'],style: TextStyle(fontSize: getWidth(16),fontWeight: FontWeight.w600),),
              value: val == 'Yes',
              onChanged: (val) =>
                  controller.setValue(key, val ? 'Yes' : 'No'),
            ),
          );
        });

      case 'checkBoxList':
        final items = jsonDecode(props['listItems']) as List;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label'] ?? '',
                style:  TextStyle(fontWeight: FontWeight.w600,fontSize: getWidth(15))),
            ...items.map((e) {
              return Obx(() {
                final list = controller.formData[key] is RxList<String>
                    ? (controller.formData[key] as RxList<String>).toList()
                    : <String>[];
                final isSelected = list.contains(e['name']);
                return CheckboxListTile(
                  title: Text(e['name']),
                  value: isSelected,
                  onChanged: (val) {
                    final updated = List<String>.from(list);
                    if (val == true) {
                      updated.add(e['name']);
                    } else {
                      updated.remove(e['name']);
                    }
                    controller.setValue(key, updated);
                  },
                );
              });
            }).toList(),
          ],
        );

      case 'imageView':
        final multi = props['multiImage'] ?? false;
        return Obx(() {
          final images = controller.formData[key] is RxList<File>
              ? (controller.formData[key] as RxList<File>).toList()
              : <File>[];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: getHeight(20),),
              Text(props['label'] ?? '',
                  style:TextStyle(fontWeight: FontWeight.w600,fontSize: getWidth(15))),
               SizedBox(height: getHeight(6)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: images
                    .map<Widget>((file) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(file,
                      width: 100, height: 100, fit: BoxFit.cover),
                ))
                    .toList(),
              ),
              TextButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text("Upload Image"),
                onPressed: () => controller.pickImage(key, multi: multi),
              ),
            ],
          );
        });

      default:
        return const SizedBox();
    }
  }
}
