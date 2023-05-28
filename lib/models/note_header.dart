import 'package:note_master/constants/status.dart';
import 'package:note_master/models/note_reminder.dart';
import 'note_detail.dart';

class NoteHeader {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  bool isPinned = false;
  String status;
  String? category;
  NoteDetail? noteDetail;
  NoteReminder? noteReminder;

  NoteHeader(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.isPinned = false,
      this.status = activeStatus,
      this.category});

  factory NoteHeader.fromJson(Map<String, dynamic> json) {
    return NoteHeader(
        id: json['ID'],
        createdAt: json['CreatedAt'],
        updatedAt: json['UpdatedAt'],
        title: json['Title'],
        isPinned: json['IsPinned'],
        status: json['Status'],
        category: json['Category']);
  }
}
