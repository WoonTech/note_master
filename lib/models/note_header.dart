import 'dart:ffi';

import 'package:note_master/constants/status.dart';
import 'note_detail.dart';

class NoteHeader{
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? remindedAt;
  String? title;
  bool isPinned = false;
  String status;
  String? category;
  NoteDetail? noteDetail;

  NoteHeader({this.id, this.createdAt, this.updatedAt, this.remindedAt,this.title, this.isPinned = false, this.status = activeStatus, this.category});

  factory NoteHeader.fromJson(Map<String, dynamic> json) {
    return NoteHeader(
      id: json['ID'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      remindedAt: json['RemindedAt'],
      title: json['Title'],
      isPinned: json['IsPinned'],
      status: json['Status'],
      category: json['Category']
    );
  }
}