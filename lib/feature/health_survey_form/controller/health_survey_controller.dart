import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';

class HealthSurveyController extends GetxController {
  final String jsonString = jsonEncode({
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
              "hintText": "ex: Alex Smith",
              "label": "Patient Name",
              "required": true
            }
          },
          {
            "id": 2,
            "key": "list_1",
            "properties": {
              "type": "dropDownList",
              "hintText": "Select gender",
              "label": "Gender",
              "required": true,
              "listItems":
              "[{\"name\":\"Male\",\"value\":1},{\"name\":\"Female\",\"value\":2},{\"name\":\"Other\",\"value\":3}]",
              "multiSelect": false
            }
          },
          {
            "id": 1,
            "key": "text_2",
            "properties": {
              "type": "text",
              "hintText": "ex: 35",
              "label": "Age",
              "required": true
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
              "hintText": "Select all that apply",
              "label": "Existing Conditions",
              "required": false,
              "listItems":
              "[{\"name\":\"Diabetes\",\"value\":1},{\"name\":\"Hypertension\",\"value\":2},{\"name\":\"Asthma\",\"value\":3},{\"name\":\"Heart Disease\",\"value\":4}]",
              "multiSelect": true
            }
          },
          {
            "id": 3,
            "key": "yesno_1",
            "properties": {
              "type": "yesno",
              "label": "Any allergies?",
              "required": false
            }
          },
          {
            "id": 1,
            "key": "text_3",
            "properties": {
              "type": "text",
              "hintText": "ex: Peanuts, Penicillin",
              "label": "If yes, specify",
              "required": false
            }
          },
          {
            "id": 4,
            "key": "image_1",
            "properties": {
              "type": "imageView",
              "label": "Upload prescription (if any)",
              "required": false,
              "multiImage": false
            }
          }
        ]
      }
    ]
  });

  late final Map<String, dynamic> formJson;
  final RxMap<String, RxInterface> formData = <String, RxInterface>{}.obs;

  @override
  void onInit() {
    super.onInit();
    formJson = jsonDecode(jsonString);
    _initFormData();
  }

  void _initFormData() {
    for (var section in formJson['sections']) {
      for (var field in section['fields']) {
        final key = field['key'];
        final type = field['properties']['type'];

        if (type == 'checkBoxList') {
          formData[key] = <String>[].obs;
        } else if (type == 'imageView') {
          formData[key] = <File>[].obs;
        } else {
          formData[key] = ''.obs;
        }
      }
    }
  }

  dynamic getValue(String key) {
    if (!formData.containsKey(key)) return null;
    final rxValue = formData[key]!;
    if (rxValue is RxList) {
      return rxValue;
    } else if (rxValue is Rx) {
      return rxValue.value;
    }
    return null;
  }

  void setValue(String key, dynamic value) {
    if (!formData.containsKey(key)) return;
    final rxValue = formData[key]!;
    if (rxValue is RxList && value is List) {
      rxValue.assignAll(value);
    } else if (rxValue is Rx) {
      rxValue.value = value;
    }
  }

  Future<void> pickImage(String key, {bool multi = false}) async {
    final picker = ImagePicker();
    if (multi) {
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final files = pickedFiles.map((e) => File(e.path)).toList();
        final existing = List<File>.from(getValue(key) ?? []);
        existing.addAll(files);
        setValue(key, existing);
      }
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setValue(key, [File(pickedFile.path)]);
      }
    }
  }

  /// -------------------- VALIDATION --------------------
  bool validateForm() {
    for (var section in formJson['sections']) {
      for (var field in section['fields']) {
        final props = field['properties'];
        final key = field['key'];
        final isRequired = props['required'] ?? false;
        final value = getValue(key);

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

  /// -------------------- PDF --------------------
  Future<File> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          List<pw.Widget> content = [];

          for (var section in formJson['sections']) {
            content.add(
              pw.Text(section['name'],
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            );
            content.add(pw.SizedBox(height: 10));

            for (var field in section['fields']) {
              final key = field['key'];
              final value = getValue(key);
              final type = field['properties']['type'];

              if (type == 'imageView' && value is List<File>) {
                content.add(pw.Text(field['properties']['label'],
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)));
                content.add(pw.SizedBox(height: 5));

                for (var imgFile in value) {
                  final imgBytes = imgFile.readAsBytesSync();
                  final image = pw.MemoryImage(imgBytes);
                  content.add(pw.Image(image, width: 200, height: 200));
                  content.add(pw.SizedBox(height: 10));
                }
              } else {
                content.add(
                  pw.Bullet(
                    text:
                    "${field['properties']['label']}: ${value is List ? value.join(', ') : value.toString()}",
                  ),
                );
              }
            }
            content.add(pw.SizedBox(height: 20));
          }

          return content;
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Health Survey Preview.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> openPdf(File file) async {
    await OpenFilex.open(file.path);
  }
}
