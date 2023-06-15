import 'package:note_master/constants/status.dart';

DateTime minReminderAt = DateTime.utc(1999, 1, 1);

class NoteReminder {
  int? id;
  int? noteId;
  DateTime remindedAt;
  int repetitionId;
  String notificationText;

  NoteReminder(
      {this.id,
      this.noteId,
      required this.remindedAt,
      required this.repetitionId,
      required this.notificationText});

  factory NoteReminder.fromJson(Map<String, dynamic> json) {
    return NoteReminder(
        id: json['ID'],
        noteId: json['NoteID'],
        remindedAt: DateTime.parse(json['RemindedAt']).toLocal(),
        repetitionId: json['Repetition'],
        notificationText: json['NotificationText']);
  }
}
