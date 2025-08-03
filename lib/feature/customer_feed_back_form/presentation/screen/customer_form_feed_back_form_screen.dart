import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_project/core/utils/constants/app_sizes.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/customer_form_controller.dart';

class CustomerFeedBackFormScreen extends StatelessWidget {
  const CustomerFeedBackFormScreen({super.key});

  @override
  Widget build(BuildContext context) {



    final controller = Get.find<CustomerFeedBackFormController >();
    final formName = controller.jsonString['formName'];
    final sections = controller.jsonString['sections'] as List;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: getHeight(80),
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: Icon(Icons.arrow_back_ios_new)),

          title: Text(formName.toString(),style: TextStyle(fontSize: getWidth(22),fontWeight: FontWeight.w500),),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding:  EdgeInsets.only(left:getWidth(16),right: getWidth(16),top: getHeight(16),bottom: getHeight(16) ),
          child: Column(
            children: sections.map((section) {
              final fields = section['fields'] as List;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section['name'],
                      style:  TextStyle(
                          fontSize: getWidth(18), fontWeight: FontWeight.bold)),
                  SizedBox(height: getHeight(12)),
                  ...fields.map((field) =>
                      _buildField(field as Map<String, dynamic>, controller)),

                 SizedBox(height: getHeight(100)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          child: const Text("Submit"),
          onPressed: () {
            controller.submitForm(sections);
          },
        ),
      ),

    );
  }


  Widget _buildField(Map<String, dynamic> field, CustomerFeedBackFormController controller) {
    final props = field['properties'] as Map<String, dynamic>;
    final key = field['key'];
    final type = props['type'];

    final labelStyle = TextStyle(
      fontSize: getWidth(16),
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade800,
    );

    final inputDecoration = InputDecoration(
      hintStyle: TextStyle(color: Colors.grey),
      hintText: props['hintText'],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );

    switch (type) {
      case 'text':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: getHeight(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['label'],style: TextStyle(fontSize: getWidth(15),fontWeight: FontWeight.w600),),
              SizedBox(height: getHeight(16),),
              TextFormField(
                decoration: inputDecoration,
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
              ),
            ],
          ),
        );

      case 'dropDownList':
        final items = (jsonDecode(props['listItems']) as List);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label'],style: TextStyle(fontSize: getWidth(15),fontWeight: FontWeight.w600),),
            SizedBox(height: getHeight(16),),
            DropdownButtonFormField(
              decoration: inputDecoration,
              items: items.map((e) {
                return DropdownMenuItem(value: e['value'], child: Text(e['name']));
              }).toList(),
              onChanged: (v) => controller.updateValue(key, v),
              validator: (value) =>
              value == null ? "Please select ${props['label']}" : null,
            ),
          ],
        );

      case 'checkBoxList':
        final items = jsonDecode(props['listItems']) as List;
        var selected = <dynamic>[].obs;
        controller.updateValue(key, selected);
        return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label'], style: labelStyle),
            SizedBox(height: getHeight(8)),
            ...items.map((item) => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
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
            title: Text(props['label'], style: labelStyle),
            value: value,
            onChanged: (val) => controller.updateValue(key, val),
          );
        });


      case 'imageView':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getHeight(10)),
            Text(props['label'], style: labelStyle),
            SizedBox(height: getHeight(10)),
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final image =
                await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  controller.updateValue(key, image.path);
                }
              },
              child: Obx(() {
                final imagePath = controller.formValues[key] ?? '';
                return Container(
                  height: getHeight(200),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade400, width: getWidth(1)),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade100,
                  ),
                  child: imagePath.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                      : const Center(
                    child: Icon(Icons.cloud_upload,
                        color: Colors.grey, size: 40),
                  ),
                );
              }),
            ),
            SizedBox(height: getHeight(16)),
          ],
        );

      default:
        return const SizedBox();
    }
  }

}