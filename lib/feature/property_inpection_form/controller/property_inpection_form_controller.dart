import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_project/core/utils/constants/app_sizes.dart';

class PropertyInspectionController extends GetxController {
  final String jsonString = jsonEncode({
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
              "hintText": "ex: 123 Main St",
              "label": "Property Address",
              "required": true
            }
          },
          {
            "id": 2,
            "key": "list_1",
            "properties": {
              "type": "dropDownList",
              "hintText": "Select property type",
              "label": "Property Type",
              "required": true,
              "listItems":
              "[{\"name\":\"Apartment\",\"value\":1},{\"name\":\"House\",\"value\":2},{\"name\":\"Commercial\",\"value\":3},{\"name\":\"Land\",\"value\":4}]",
              "multiSelect": false
            }
          },
          {
            "id": 1,
            "key": "text_2",
            "properties": {
              "type": "text",
              "hintText": "ex: 1500 sq ft",
              "label": "Area (sq ft)",
              "required": true
            }
          },
          {
            "id": 3,
            "key": "yesno_1",
            "properties": {
              "type": "yesno",
              "label": "Is the property furnished?",
              "required": false
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
              "hintText": "Select issues found",
              "label": "Defects Found",
              "required": false,
              "listItems":
              "[{\"name\":\"Cracks in Walls\",\"value\":1},{\"name\":\"Leaking Roof\",\"value\":2},{\"name\":\"Faulty Wiring\",\"value\":3},{\"name\":\"Plumbing Issues\",\"value\":4}]",
              "multiSelect": true
            }
          },
          {
            "id": 4,
            "key": "image_1",
            "properties": {
              "type": "imageView",
              "label": "Upload photos of defects",
              "required": false,
              "multiImage": true
            }
          },
          {
            "id": 1,
            "key": "text_3",
            "properties": {
              "type": "text",
              "hintText": "ex: Major structural damage observed",
              "label": "Additional Notes",
              "required": false
            }
          }
        ]
      }
    ]
  });

  late final Map<String, dynamic> formJson;
  var formData = <String, Rx<dynamic>>{}.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    formJson = jsonDecode(jsonString);
    _initializeFields();
  }

  void _initializeFields() {
    for (var section in formJson['sections']) {
      for (var field in section['fields']) {
        final type = field['properties']['type'];
        if (type == 'checkBoxList') {
          formData[field['key']] = Rx<List<String>>([]);
        } else if (type == 'imageView') {
          formData[field['key']] = Rx<List<File>>([]);
        } else {
          formData[field['key']] = ''.obs;
        }
      }
    }
  }

  void setValue(String key, dynamic value) {
    formData[key]?.value = value;
  }

  Future<void> pickImage(String key, {bool multi = true}) async {
    if (multi) {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final current = List<File>.from(formData[key]?.value ?? []);
        current.addAll(pickedFiles.map((e) => File(e.path)));
        formData[key]?.value = current;
      }
    } else {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        formData[key]?.value = [File(picked.path)];
      }
    }
  }

  /// ------------------- VALIDATION -------------------
  bool validateForm() {
    for (var section in formJson['sections']) {
      for (var field in section['fields']) {
        final props = field['properties'];
        final key = field['key'];
        final isRequired = props['required'] ?? false;
        final value = formData[key]?.value;

        if (isRequired) {
          if (props['type'] == 'text' || props['type'] == 'dropDownList') {
            if (value == null || value.toString().trim().isEmpty) {
              Get.snackbar("Missing Field",
                  "Please fill in '${props['label']}' before submitting.");
              return false;
            }
          } else if (props['type'] == 'checkBoxList') {
            if (value is List && value.isEmpty) {
              Get.snackbar("Missing Field",
                  "Please select at least one option for '${props['label']}'.");
              return false;
            }
          } else if (props['type'] == 'imageView') {
            if (value is List && value.isEmpty) {
              Get.snackbar("Missing Field",
                  "Please upload image(s) for '${props['label']}'.");
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  /// ------------------- PDF -------------------
  Future<File> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Text(formJson['formName'],
                style: pw.TextStyle(
                    fontSize: getWidth(20), fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: getHeight(20)),
            ...formJson['sections'].map<pw.Widget>((section) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(section['name'],
                      style: pw.TextStyle(
                          fontSize: getWidth(16),
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: getHeight(12)),
                  ...section['fields'].map<pw.Widget>((field) {
                    final value = formData[field['key']]?.value ?? '';
                    if (field['properties']['type'] == 'imageView' &&
                        value is List<File>) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(field['properties']['label']),
                          pw.Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: value.map<pw.Widget>((file) {
                              final image =
                              pw.MemoryImage(file.readAsBytesSync());
                              return pw.Image(image,
                                  width: getWidth(100), height: getHeight(100));
                            }).toList(),
                          )
                        ],
                      );
                    } else {
                      return pw.Text(
                          '${field['properties']['label']}: ${value is List ? value.join(", ") : value}');
                    }
                  }).toList()
                ],
              );
            }).toList(),
          ];
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/property_inspection_form_preview.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> openPdf(File file) async {
    await OpenFilex.open(file.path);
  }
}
