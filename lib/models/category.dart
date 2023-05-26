import 'package:note_master/constants/status.dart';

class NMCategory{
  int? id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String? status = activeStatus;
  String? type = "";

  NMCategory({this.id, required this.createdAt, required this.updatedAt, required this.name, this.status, this.type});

  factory NMCategory.fromJson(Map<String, dynamic> json) {
    return NMCategory(
      id: json['ID'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      name: json['Name'],
      status: json['Status'],
      type: json['Type']
    );
  }
}