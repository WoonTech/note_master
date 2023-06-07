import 'package:note_master/constants/status.dart';
import 'package:note_master/models/notedetail.dart';
import 'package:note_master/models/notereminder.dart';

class NoteHeader {
  int? id;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  bool isPinned = false;
  String status;
  String category;
  NoteDetail? noteDetail;
  NoteReminder? noteReminder;

  NoteHeader(
      {this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      this.isPinned = false,
      this.status = activeStatus,
      required this.category});

  factory NoteHeader.fromJson(Map<String, dynamic> json) {
    var noteHeader = NoteHeader(
        id: json['ID'],
        createdAt: DateTime.parse(json['CreatedAt']),
        updatedAt: DateTime.parse(json['UpdatedAt']),
        title: json['Title'],
        isPinned: bool.fromEnvironment(json['IsPinned']),
        status: json['Status'],
        category: json['CategoryID']);
    noteHeader.noteDetail =
        NoteDetail(id: json['DetailID'], content: json['Content']);
    var notificationId = json['NoteReminder.ID'];
    if (notificationId != null) {
      noteHeader.noteReminder = NoteReminder(
          id: json['NoteReminder.ID'],
          noteId: json['NoteReminder.NoteID'],
          createdAt: DateTime.parse(json['NoteReminder.CreatedAt']),
          updatedAt: DateTime.parse(json['NoteReminder.UpdatedAt']),
          remindedAt: DateTime.parse(json['NoteReminder.RemindedAt']),
          repetition: json['NoteReminder.Repetition'],
          notificationText: json['NoteReminder.NotificationText']);
    }
    return noteHeader;
  }

  /*String getNotesQuery = category == category_default
      ? '''
  Select NoteHeader.*,NoteDetail.* from NoteHeader 
  INNER JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID
  '''
      : '''
  Select NoteHeader.*,NoteDetail.* from NoteHeader 
  INNER JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID where NoteHeader.CategoryID = ?
  ''';*/
}
