import 'package:note_master/constants/status.dart';

class NoteReminder {
  int? id;
  int? noteId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime remindedAt;
  int repetition;
  String notificationText;

  NoteReminder(
      {this.id,
      this.noteId,
      required this.createdAt,
      required this.updatedAt,
      required this.remindedAt,
      required this.repetition,
      required this.notificationText});

  factory NoteReminder.fromJson(Map<String, dynamic> json) {
    return NoteReminder(
        id: json['ID'],
        noteId: json['NoteID'],
        createdAt: DateTime.parse(json['CreatedAt']),
        updatedAt: DateTime.parse(json['UpdatedAt']),
        remindedAt: DateTime.parse(json['RemindedAt']),
        repetition: json['Repetition'],
        notificationText: json['NotificationText']);
  }
}
