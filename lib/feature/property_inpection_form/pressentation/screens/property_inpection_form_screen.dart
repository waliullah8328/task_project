import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_project/core/utils/constants/app_sizes.dart';
import '../../controller/property_inpection_form_controller.dart';
import 'property_form_submission screen.dart';

class PropertyInpectionFormScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final controller = Get.find<PropertyInspectionController>();

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
          children:controller. formJson['sections'].map<Widget>((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section['name'],
                    style:  TextStyle(
                        fontSize: getWidth(18), fontWeight: FontWeight.bold)),
                SizedBox(height: getHeight(12)),
                ...section['fields'].map<Widget>((field) {
                  return _buildField(controller, field);
                }).toList(),
                const SizedBox(height: 20)
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
                Get.to(() =>  FormPreviewPage());
              }
            },



        ),
      ),
    );
  }

  Widget _buildField(PropertyInspectionController controller, dynamic field) {
    final props = field['properties'];
    switch (props['type']) {
      case 'text':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label'],style: TextStyle(fontSize: getWidth(15),fontWeight: FontWeight.w600),),
            SizedBox(height: getHeight(16),),
            TextField(
              decoration: InputDecoration(
                //labelText: props['label'],
                hintText: props['hintText'],
                hintStyle: TextStyle(color: Colors.grey)
              ),
              onChanged: (v) => controller.setValue(field['key'], v),
            ),
          ],
        );
      case 'dropDownList':
        final items = (jsonDecode(props['listItems']) as List)
            .map((e) => DropdownMenuItem(
          value: e['name'],
          child: Text(e['name']),
        ))
            .toList();
        return Obx(() => Padding(
          padding:  EdgeInsets.only(top: getHeight(16),bottom: getWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['label'],style: TextStyle(fontSize: getWidth(15),fontWeight: FontWeight.w600),),
              SizedBox(height: getHeight(16),),
              DropdownButtonFormField(
                items: items,
                value: controller.formData[field['key']]?.value == ''
                    ? null
                    : controller.formData[field['key']]?.value,
                onChanged: (val) => controller.setValue(field['key'], val),
                decoration: InputDecoration(hintText: props['hintText']),
              ),
            ],
          ),
        ));
      case 'yesno':
        return Obx(() => Padding(
          padding:  EdgeInsets.only(top: getHeight(16),bottom: getWidth(16)),
          child: SwitchListTile(
            title: Text(props['label'],style: TextStyle(fontSize: getWidth(16),fontWeight: FontWeight.w600),),
            value: controller.formData[field['key']]?.value == 'Yes',
            onChanged: (val) =>
                controller.setValue(field['key'], val ? 'Yes' : 'No'),
          ),
        ));
      case 'checkBoxList':
        final items = jsonDecode(props['listItems']) as List;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label'],
                style:  TextStyle(fontWeight: FontWeight.w600,fontSize: getWidth(15))),
            ...items.map((e) {
              return Obx(() {
                final list =
                List<String>.from(controller.formData[field['key']]?.value);
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
                    controller.setValue(field['key'], updated);
                  },
                );
              });
            }).toList()
          ],
        );
      case 'imageView':
        return Obx(() {
          final images = List<File>.from(controller.formData[field['key']]?.value ?? []);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['label'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: images
                    .map((file) => Image.file(file, width: 80, height: 80, fit: BoxFit.cover))
                    .toList(),
              ),
              TextButton.icon(
                onPressed: () => controller.pickImage(field['key'], multi: props['multiImage'] ?? false),
                icon: const Icon(Icons.add_a_photo),
                label: const Text("Add Images"),
              ),
            ],
          );
        });

      default:
        return const SizedBox();
    }
  }
}
