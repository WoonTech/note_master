import 'package:note_master/constants/status.dart';
import 'note_detail.dart';

class NoteReminder {
  int? id;
  int noteId;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime remindedAt;
  String repetition;
  String notificationText;

  NoteReminder(
      {this.id,
      required this.noteId,
      required this.createdAt,
      required this.updatedAt,
      required this.remindedAt,
      required this.repetition,
      required this.notificationText});

  factory NoteReminder.fromJson(Map<String, dynamic> json) {
    return NoteReminder(
        id: json['ID'],
        noteId: json['NoteID'],
        createdAt: json['CreatedAt'],
        updatedAt: json['UpdatedAt'],
        remindedAt: json['RemindedAt'],
        repetition: json['Repetition'],
        notificationText: json['NotificationText']);
  }
}
