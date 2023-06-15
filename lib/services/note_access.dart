import 'package:note_master/models/layout.dart';
import 'package:note_master/models/notereminder.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category.dart';
import '../models/notedetail.dart';
import '../models/noteheader.dart';
import '../utils/data_access.dart';

Future<NoteHeader> saveNoteAsync(NoteHeader noteHeader) async {
  if (noteHeader.id == null) {
    return await postNoteAsync(noteHeader);
  } else {
    return await patchNoteAsync(noteHeader);
  }
}

Future<NoteHeader> postNoteAsync(NoteHeader noteHeader) async {
  await postNoteHeaderAsync(noteHeader);
  var latestNoteId = await getLastUpdatedNoteIdAsync() ?? 0;
  if (latestNoteId != 0) {
    noteHeader.id = latestNoteId;
    await postNoteDetailAsync(latestNoteId, noteHeader.noteDetail!);
    noteHeader.noteDetail?.id = await getNoteDetailsIdAsync(latestNoteId);
    await postNoteReminderAsync(latestNoteId, noteHeader.noteReminder!);
    noteHeader.noteReminder?.id = await getNoteRemindersIdAsync(latestNoteId);
  }
  return noteHeader;
}

Future<int?> postNoteHeaderAsync(NoteHeader noteHeader) async {
  var db = (await database);
  try {
    await db.transaction((txn) async {
      await txn.insert('NoteHeader', {
        'CreatedAt': noteHeader.createdAt.toIso8601String(),
        'UpdatedAt': noteHeader.updatedAt.toIso8601String(),
        'Title': noteHeader.title.trim(),
        'IsPinned': noteHeader.isPinned.toString(),
        'Status': noteHeader.status,
        'CategoryID': noteHeader.category
      });
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future postNoteDetailAsync(int noteId, NoteDetail noteDetail) async {
  var db = (await database);
  try {
    await db.transaction((txn) async {
      var id = await txn.insert('NoteDetail', {
        'NoteID': noteId,
        'Content': noteDetail.content,
      });
      print('successfully');
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future postNoteReminderAsync(int noteId, NoteReminder noteReminder) async {
  var db = (await database);
  try {
    await db.transaction((txn) async {
      await txn.insert('NoteReminder', {
        'NoteID': noteId,
        'ReminderAt': noteReminder.remindedAt.toIso8601String(),
        'Repetition': noteReminder.repetitionId,
        'NotificationText': noteReminder.notificationText
      });
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<NoteHeader>> getNotesAsync(
    {String category = category_default}) async {
  String getNotesQuery = category == category_default
      ? '''
  Select NoteHeader.*, 
  NoteDetail.ID as DetailID, NoteDetail.Content, 
  NoteReminder.ID as ReminderID, NoteReminder.ReminderAt as ReminderAt, NoteReminder.Repetition as Repetition, NoteReminder.NotificationText as NotificationText from NoteHeader 
  LEFT JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID
  LEFT JOIN NoteReminder ON NoteHeader.ID = NoteReminder.NoteID
  '''
      : '''
  Select NoteHeader.*,
  NoteDetail.ID as DetailID, NoteDetail.Content, 
  NoteReminder.ID as ReminderID, NoteReminder.ReminderAt as ReminderAt, NoteReminder.Repetition as Repetition, NoteReminder.NotificationText as NotificationText from NoteHeader 
  LEFT JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID
  LEFT JOIN NoteReminder ON NoteHeader.ID = NoteReminder.NoteID
  where NoteHeader.CategoryID = ?
  ''';

  var db = (await database);
  var results = category == category_default
      ? await db.rawQuery(getNotesQuery)
      : await db.rawQuery(getNotesQuery, [category]);
  try {
    return List.generate(results.length, (index) {
      return NoteHeader.fromJson(results[index]);
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future<NoteHeader?> getNoteAsync(String noteID) async {
  String getNoteQuery = '''
  Select NoteHeader.*,NoteDetail.* from NoteHeader 
  INNER JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID 
  WHERE NoteHeader.ID = ?
  ''';
  var db = (await database);

  try {
    var result = (await db.rawQuery(getNoteQuery, [noteID])).first;
    return NoteHeader.fromJson(result);
  } on StateError catch (e) {
    print('Unable to fetch note detail with note ID # $noteID ,$e');
    return null;
  }
}

Future<int?> getLastUpdatedNoteIdAsync() async {
  String getNoteQuery = '''
  Select ID from NoteHeader Order By ID DESC LIMIT 1;
  ''';
  var db = (await database);
  try {
    var result = (await db.rawQuery(getNoteQuery)).first;
    Map<String, dynamic> json = result;
    return json['ID'];
  } on StateError catch (e) {
    return null;
  }
}

Future<int?> getNoteDetailsIdAsync(int noteId) async {
  String getNoteQuery = '''
  Select ID from NoteDetail Where NoteID= ? LIMIT 1;
  ''';
  var db = (await database);
  try {
    var result = (await db.rawQuery(getNoteQuery, [noteId])).first;
    Map<String, dynamic> json = result;
    return json['ID'];
  } on StateError catch (e) {
    return 0;
  }
}

Future<int?> getNoteRemindersIdAsync(int noteId) async {
  String getNoteQuery = '''
  Select ID from NoteReminder Where NoteID= ? LIMIT 1;
  ''';
  var db = (await database);
  try {
    var result = (await db.rawQuery(getNoteQuery, [noteId])).first;
    Map<String, dynamic> json = result;
    return json['ID'];
  } on StateError catch (e) {
    return 0;
  }
}

Future<NoteHeader> patchNoteAsync(NoteHeader note) async {
  DateTime updatedAt = DateTime.now();
  var db = (await database);
  try {
    await db.transaction((txn) async {
      await txn.update(
          'NoteHeader',
          {
            'UpdatedAt': updatedAt.toIso8601String(),
            'Title': note.title.trim(),
            'IsPinned': note.isPinned.toString(),
            'Status': note.status,
            'CategoryID': note.category
          },
          where: 'Id = ?',
          whereArgs: [note.id]);
      await txn.update(
          'NoteDetail',
          {
            'Content': note.noteDetail?.content,
          },
          where: 'NoteID = ?',
          whereArgs: [note.id]);
      await txn.update(
          'NoteReminder',
          {
            'ReminderAt': note.noteReminder?.remindedAt.toIso8601String(),
            'Repetition': note.noteReminder?.repetitionId,
            'NotificationText': note.noteReminder?.notificationText
          },
          where: 'NoteID = ?',
          whereArgs: [note.id]);
    });
    note.updatedAt = updatedAt;
    return note;
  } catch (e) {
    throw Exception(e);
  }
}

Future deleteNote(int noteId) async {
  DateTime updatedAt = DateTime.now();
  var db = (await database);
  try {
    await db.transaction((txn) async {
      await txn.delete('NoteHeader', where: 'Id = ?', whereArgs: [noteId]);
      await txn.delete('NoteDetail', where: 'NoteID = ?', whereArgs: [noteId]);
    });
  } catch (e) {
    throw Exception(e);
  }
}
