import 'package:note_master/constants/status.dart';

const String category_default = 'All';
const String note_type = 'note';
const String checklist_type = 'checklist';

class NoteCategory {
  int? id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String? status = activeStatus;
  String? type = "";
  int colorId;
  NoteCategory(
      {this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.status,
      required this.type,
      required this.colorId});

  factory NoteCategory.fromJson(Map<String, dynamic> json) {
    return NoteCategory(
        id: json['ID'],
        createdAt: DateTime.parse(json['CreatedAt']).toLocal(),
        updatedAt: DateTime.parse(json['UpdatedAt']).toLocal(),
        name: json['CategoryName'],
        status: json['Status'],
        type: json['Type'],
        colorId: int.parse(json['ColorID']));
  }
}
