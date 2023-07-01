import 'package:note_master/constants/status.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/notedetail.dart';
import 'package:note_master/models/notereminder.dart';

class NoteHeader {
  int? id;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  bool isPinned = false;
  String status;
  int? categoryId;
  NoteDetail? noteDetail;
  NoteReminder? noteReminder;

  NoteHeader(
      {this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.title,
      this.isPinned = false,
      this.status = activeStatus,
      this.categoryId = category_default_ID});

  factory NoteHeader.fromJson(Map<String, dynamic> json) {
    var noteHeader = NoteHeader(
        id: json['ID'],
        createdAt: DateTime.parse(json['CreatedAt']).toLocal(),
        updatedAt: DateTime.parse(json['UpdatedAt']).toLocal(),
        title: json['Title'],
        isPinned: json['IsPinned'] == "true" ? true : false,
        status: json['Status'],
        categoryId: int.parse(json['CategoryID']));
    noteHeader.noteDetail = NoteDetail(
        id: json['DetailID'], noteId: json['ID'], content: json['Content']);
    var notificationId = json['ReminderID'];
    if (notificationId != null) {
      noteHeader.noteReminder = NoteReminder(
          id: json['ReminderID'],
          noteId: json['ID'],
          remindedAt: DateTime.parse(json['RemindedAt']).toLocal(),
          repetitionId: int.parse(json['RepetitionID']),
          notificationText: json['NotificationText']);
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
