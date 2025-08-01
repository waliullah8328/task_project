class FormFieldProperties {
  String type;
  String label;
  String hintText;
  String defaultValue;
  int? minLength;
  int? maxLength;
  bool? multiSelect;
  String? listItems;
  bool? multiImage;

  FormFieldProperties({
    required this.type,
    required this.label,
    required this.hintText,
    required this.defaultValue,
    this.minLength,
    this.maxLength,
    this.multiSelect,
    this.listItems,
    this.multiImage,
  });

  factory FormFieldProperties.fromJson(Map<String, dynamic> json) =>
      FormFieldProperties(
        type: json['type'],
        label: json['label'],
        hintText: json['hintText'] ?? '',
        defaultValue: json['defaultValue'] ?? '',
        minLength: json['minLength'],
        maxLength: json['maxLength'],
        multiSelect: json['multiSelect'],
        listItems: json['listItems'],
        multiImage: json['multiImage'],
      );
}

class FormFieldData {
  int id;
  String key;
  FormFieldProperties properties;

  FormFieldData({required this.id, required this.key, required this.properties});

  factory FormFieldData.fromJson(Map<String, dynamic> json) => FormFieldData(
    id: json['id'],
    key: json['key'],
    properties: FormFieldProperties.fromJson(json['properties']),
  );
}

class FormSection {
  String name;
  String key;
  List<FormFieldData> fields;

  FormSection({required this.name, required this.key, required this.fields});

  factory FormSection.fromJson(Map<String, dynamic> json) => FormSection(
    name: json['name'],
    key: json['key'],
    fields: (json['fields'] as List)
        .map((e) => FormFieldData.fromJson(e))
        .toList(),
  );
}

class DynamicFormModel {
  String formName;
  int id;
  List<FormSection> sections;

  DynamicFormModel({
    required this.formName,
    required this.id,
    required this.sections,
  });

  factory DynamicFormModel.fromJson(Map<String, dynamic> json) =>
      DynamicFormModel(
        formName: json['formName'],
        id: json['id'],
        sections: (json['sections'] as List)
            .map((e) => FormSection.fromJson(e))
            .toList(),
      );
}
