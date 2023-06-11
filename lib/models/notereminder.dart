import 'package:note_master/constants/status.dart';

class NoteReminder {
  int? id;
  int? noteId;
  DateTime remindedAt;
  int repetition;
  String notificationText;

  NoteReminder(
      {this.id,
      this.noteId,
      required this.remindedAt,
      required this.repetition,
      required this.notificationText});

  factory NoteReminder.fromJson(Map<String, dynamic> json) {
    return NoteReminder(
        id: json['ID'],
        noteId: json['NoteID'],
        remindedAt: DateTime.parse(json['RemindedAt']).toLocal(),
        repetition: json['Repetition'],
        notificationText: json['NotificationText']);
  }
}
