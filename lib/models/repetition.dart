import 'package:note_master/constants/status.dart';

class NoteRepetition {
  int? id;
  String repetitionText;

  NoteRepetition(
      {this.id,
      required this.repetitionText}
  );

  factory NoteRepetition.fromJson(Map<String, dynamic> json) {
    return NoteRepetition(
        id: json['ID'],
        repetitionText: json['RepetitionText']);
  }
}
