import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';

import '../../../../core/utils/constants/app_sizes.dart';

class SubmissionViewPage extends StatelessWidget {
  final Map<String, dynamic> formData;
  final List sections;

  const SubmissionViewPage({
    super.key,
    required this.formData,
    required this.sections,
  });

  Future<void> savePdfInvoice() async {
    final pdf = pw.Document();

    // Pre-build PDF content (including images)
    final widgets = await _buildPdfRows();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text("Invoice",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          ...widgets,
        ],
      ),
    );

    // Save to Downloads folder
    final dir = await getDownloadsDirectory();
    final filePath =
        '${dir!.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    Get.snackbar("Saved", "Invoice saved to Downloads folder");
    await OpenFilex.open(filePath);
  }

  Future<List<pw.Widget>> _buildPdfRows() async {
    List<pw.Widget> widgets = [];

    for (var section in sections) {
      widgets.add(
        pw.Text(section['name'],
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      );
      widgets.add(pw.SizedBox(height: 10));

      for (var field in section['fields']) {
        final props = field['properties'];
        final key = field['key'];
        final type = props['type'];
        final rawValue = formData[key];

        String displayValue = '';

        if (type == 'dropDownList') {
          final items = _parseListItems(props['listItems']);
          final selected =
          items.firstWhere((e) => e['value'] == rawValue, orElse: () => {});
          displayValue = selected.isNotEmpty ? selected['name'] : '';
        } else if (type == 'checkBoxList') {
          final items = _parseListItems(props['listItems']);
          if (rawValue is List) {
            displayValue = rawValue
                .map((v) => items
                .firstWhere((e) => e['value'] == v, orElse: () => {})
                .putIfAbsent('name', () => ''))
                .join(', ');
          }
        } else if (type == 'imageView') {
          if (rawValue != null && rawValue.toString().isNotEmpty) {
            final imageFile = File(rawValue);
            if (await imageFile.exists()) {
              final image = pw.MemoryImage(await imageFile.readAsBytes());
              widgets.add(pw.Text(props['label'],
                  style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)));
              widgets.add(pw.SizedBox(height: 5));
              widgets.add(pw.Image(image, width: 150, height: 150));
              widgets.add(pw.SizedBox(height: 10));
              continue;
            }
          }
        } else {
          displayValue = rawValue?.toString() ?? '';
        }

        widgets.add(
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text("${props['label']}:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Expanded(child: pw.Text(displayValue)),
            ],
          ),
        );
        widgets.add(pw.Divider());
      }
      widgets.add(pw.SizedBox(height: 20));
    }
    return widgets;
  }

  List<Map<String, dynamic>> _parseListItems(String jsonString) {
    try {
      return List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    } catch (_) {
      return [];
    }
  }

  String _getDisplayValue(Map<String, dynamic> props, dynamic rawValue) {
    final type = props['type'];
    if (type == 'dropDownList') {
      final items = _parseListItems(props['listItems']);
      final selected =
      items.firstWhere((e) => e['value'] == rawValue, orElse: () => {});
      return selected.isNotEmpty ? selected['name'] : '';
    } else if (type == 'checkBoxList') {
      final items = _parseListItems(props['listItems']);
      if (rawValue is List) {
        return rawValue
            .map((v) => items
            .firstWhere((e) => e['value'] == v, orElse: () => {})
            .putIfAbsent('name', () => ''))
            .join(', ');
      }
    }
    return rawValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];

    for (var section in sections) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(section['name'],
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      );

      for (var field in section['fields']) {
        final props = field['properties'];
        final key = field['key'];
        final type = props['type'];
        final value = formData[key];

        // Handle image preview separately
        if (type == 'imageView' && value != null && value.toString().isNotEmpty) {
          final imageFile = File(value);
          if (imageFile.existsSync()) {
            rows.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(props['label'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Image.file(imageFile, width: 150, height: 150),
                  const Divider(),
                ],
              ),
            );
            continue;
          }
        }

        final displayValue = _getDisplayValue(props, value);

        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("${props['label']}:",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Text(displayValue),
              ),
            ],
          ),
        );
        rows.add(const Divider());
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
        onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new)),

        title: Text("Submission Preview",style: TextStyle(fontSize: getWidth(22),fontWeight: FontWeight.w500),),
        centerTitle: true,

        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: rows),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: savePdfInvoice,
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
