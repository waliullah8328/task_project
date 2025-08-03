import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../controller/property_inpection_form_controller.dart';

class FormPreviewPage extends StatelessWidget {
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
        title: Text("Property Inspection Form Preview",style: TextStyle(fontSize: getWidth(22),fontWeight: FontWeight.w500),),
      ),

      body: Obx(
            () => ListView(
              padding: EdgeInsets.only(left: getWidth(16),right: getWidth(16),top: getHeight(16),bottom: getHeight(16)),
          children: controller.formJson['sections'].map<Widget>((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section['name'],
                    style:  TextStyle(
                        fontSize: getWidth(18), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...section['fields'].map<Widget>((field) {
                  final value = controller.formData[field['key']]?.value ?? '';
                  final fieldType = field['properties']['type'];

                  if (fieldType == 'imageView' && value is List<File>) {
                    // Show image thumbnails
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(field['properties']['label'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                         SizedBox(height: getHeight(10)),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: value
                              .map((file) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(file,
                                width: getWidth(100),
                                height: getHeight(100),
                                fit: BoxFit.cover),
                          ))
                              .toList(),
                        ),
                         SizedBox(height: getHeight(10)),
                      ],
                    );
                  } else {
                    return ListTile(
                      title: Text(field['properties']['label'],style: TextStyle(fontSize: getWidth(16),fontWeight: FontWeight.w600),),
                      subtitle: Text(
                        value is List
                            ? value.join(', ')
                            : value.toString(),
                          style: TextStyle(fontSize: getWidth(14),fontWeight: FontWeight.w600)
                      ),
                    );
                  }
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
          child: const Text("Download Preview PDF"),
          onPressed: () async {
            final file = await controller.generatePdf();
            await controller.openPdf(file);
          },
        ),
      ),
    );
  }
}
