import 'package:note_master/models/notereminder.dart';
import 'package:sqflite/sqflite.dart';

import '../models/category.dart';
import '../models/notedetail.dart';
import '../models/noteheader.dart';
import '../utils/data_access.dart';

Future saveNoteAsync(NoteHeader noteHeader) async {
  if(noteHeader.id == null){
    await postNoteAsync(noteHeader);
  }
  else{
    await patchNoteAsync(noteHeader);
  }
}

Future postNoteAsync(NoteHeader noteHeader) async {
  await postNoteHeaderAsync(noteHeader);
  var latestNoteId = await getLastUpdatedNoteIdAsync() ?? 0;
  if(latestNoteId != 0){
    await postNoteDetailAsync(latestNoteId, noteHeader.noteDetail!);
    if(noteHeader.noteReminder != null){
      await postNoteReminderAsync(latestNoteId, noteHeader.noteReminder!);
    }
  }

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
        'CreatedAt': noteReminder.createdAt.toIso8601String(),
        'UpdatedAt': noteReminder.updatedAt.toIso8601String(),
        'Content': noteReminder.remindedAt.toIso8601String(),
        'Repetition': noteReminder.repetition,
        'NotificationText': noteReminder.notificationText
      });
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<NoteHeader>> getNotesAsync({String category = category_default}) async {
  String getNotesQuery = category == category_default
      ? '''
  Select NoteHeader.*, NoteDetail.Content, NoteDetail.ID as DetailID from NoteHeader 
  LEFT JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID
  '''
      : '''
  Select NoteHeader.*, NoteDetail.Content from NoteHeader 
  LEFT JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID where NoteHeader.CategoryID = ?
  ''';

  var db = (await database);
  var results = category == category_default
      ? await db.rawQuery(getNotesQuery)
      : await db.rawQuery(getNotesQuery, [category]);
  print(results.toString());  
  try {
      return List.generate(results.length, (index) {
      return NoteHeader.fromJson(results[index]);
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future<NoteHeader?> getNoteAsync(String noteID) async {
  String getNoteQuery = 
  '''
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
  String getNoteQuery = 
  '''
  Select ID from NoteHeader Order By UpdatedAt DESC LIMIT 1;
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

Future patchNoteAsync(NoteHeader note) async {
  DateTime updatedAt = DateTime.now();
  var db = (await database);
  try {
    await db.transaction((txn) async {
      await txn.update(
          'NoteHeader',
          {
            'UpdatedAt': updatedAt.toIso8601String(),
            'Title': note.title?.trim(),
            'IsPinned': note.isPinned.toString(),
            'Status': note.status,
            'CategoryID': note.category
          },
          where: 'Id = ?',
          whereArgs: [note.id]);
      await txn.update(
          'NoteDetail',
          {
            'UpdatedAt': updatedAt.toIso8601String(),
            'Content': note.noteDetail?.content,
          },
          where: 'NoteID = ?',
          whereArgs: [note.id]);
    });
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
