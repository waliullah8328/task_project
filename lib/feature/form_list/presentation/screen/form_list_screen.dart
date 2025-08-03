import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_project/feature/property_inpection_form/pressentation/screens/property_inpection_form_screen.dart';
import 'package:task_project/routes/app_routes.dart';

import '../../../../core/utils/constants/app_sizes.dart';
import '../../../customer_feed_back_form/presentation/screen/customer_form_feed_back_form_screen.dart';
import '../../../health_survey_form/presentation/screens/health_survey_form_screen.dart';

class FormListPage extends StatelessWidget {
  const FormListPage({super.key});

  final List<Map<String, dynamic>> forms = const [
    {
      "title": "Customer Feedback Form",
      "description": "Collect feedback from customers about products & services.",
      "icon": Icons.feedback
    },
    {
      "title": "Property Inspection Form",
      "description": "Record property inspection details quickly.",
      "icon": Icons.house
    },
    {
      "title": "Health Survey Form",
      "description": "Gather health information & daily habits.",
      "icon": Icons.health_and_safety
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Forms Screens"),
        backgroundColor: Colors.white,
        toolbarHeight: getHeight(80),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: forms.length,
        itemBuilder: (context, index) {
          final form = forms[index];
          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  Get.to(() => const CustomerFeedBackFormScreen ());
                  break;
                case 1:
                  Get.to(()=> PropertyInpectionFormScreen());
                  break;
                case 2:
                  Get.to(() =>  HealthSurveyFormScreen());
                  break;
                default:
                  Get.snackbar("Error", "Form not implemented");
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(
                        form['icon'],
                        size: 30,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(form['title'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(
                            form['description'],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 18)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
