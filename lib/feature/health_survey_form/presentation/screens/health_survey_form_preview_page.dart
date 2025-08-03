import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/app_sizes.dart';
import '../../controller/health_survey_controller.dart';

class HealthSurveyFormPreviewPage extends StatelessWidget {
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
        title: Text("Health Survey Preview Screen",style: TextStyle(fontSize: getWidth(22),fontWeight: FontWeight.w500),),
      ),

      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: controller.formJson['sections'].map<Widget>((section) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section['name'] ?? '',
                  style: TextStyle(
                    fontSize: getWidth(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: getHeight(10)),
                ...section['fields'].map<Widget>((field) {
                  final key = field['key'];
                  final type = field['properties']['type'];

                  final rxValue = controller.formData[key];
                  dynamic value = '';

                  if (rxValue == null) {
                    value = '';
                  } else if (rxValue is RxList) {
                    value = rxValue.toList();
                  } else if (rxValue is Rx) {
                    value = (rxValue as Rx).value;
                  } else {
                    value = rxValue;
                  }

                  if (type == 'imageView' && value is List<File>) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field['properties']['label'] ?? '',
                          style:  TextStyle(fontWeight: FontWeight.w600,fontSize: getWidth(15)),
                        ),
                        SizedBox(height: getHeight(10)),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: value
                              .map<Widget>((file) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              file,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  } else {
                    return ListTile(
                      title: Text(field['properties']['label'] ?? '',style: TextStyle(fontSize: getWidth(16),fontWeight: FontWeight.w600),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: getHeight(8),),
                          Text(
                            value is List ? value.join(', ') : value.toString(),

                  style: TextStyle(fontSize: getWidth(14),fontWeight: FontWeight.w400
                          ))
                          ,
                        ],
                      ),
                    );
                  }
                }).toList(),
                const SizedBox(height: 20)
              ],
            );
          }).toList(),
        );
      }),
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
