import 'package:note_master/constants/status.dart';

const String category_default = 'All';
const String note_type = 'note';
const String checklist_type = 'checklist';

class NMCategory {
  int? id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String? status = activeStatus;
  String? type = "";

  NMCategory(
      {this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.status,
      required this.type});

  factory NMCategory.fromJson(Map<String, dynamic> json) {
    return NMCategory(
        id: json['ID'],
        createdAt: DateTime.parse(json['CreatedAt']).toLocal(),
        updatedAt: DateTime.parse(json['UpdatedAt']).toLocal(),
        name: json['CategoryName'],
        status: json['Status'],
        type: json['Type']);
  }
}
