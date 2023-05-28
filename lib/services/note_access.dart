import 'package:note_master/models/note_reminder.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/category.dart';
import '../models/note_detail.dart';
import '../models/note_header.dart';
import '../utils/data_access.dart';

Future postNoteAsync(NoteHeader noteHeader) async {
  var noteId = await postNoteHeaderAsync(noteHeader);
  if (noteHeader.noteDetail != null) {
    postNoteDetailAsync(noteId!, noteHeader.noteDetail!);
  }
  if (noteHeader.noteReminder != null) {
    postNoteReminderAsync(noteId!, noteHeader.noteReminder!);
  }
}

Future<int?> postNoteHeaderAsync(NoteHeader noteHeader) async {
  var db = await openDatabase(dbName);
  try {
    await db.transaction((txn) async {
      return await db.insert('NoteHeader', {
        'CreatedAt': noteHeader.createdAt?.toIso8601String(),
        'UpdatedAt': noteHeader.updatedAt?.toIso8601String(),
        'Title': noteHeader.title?.trim(),
        'IsPinned': noteHeader.isPinned.toString(),
        'Status': noteHeader.status,
        'Category': noteHeader.category
      });
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.close();
  }
}

Future postNoteDetailAsync(int noteId, NoteDetail noteDetail) async {
  var db = await openDatabase(dbName);
  try {
    await db.transaction((txn) async {
      var id = await db.insert('NoteDetail', {
        'NoteID': noteId,
        'CreatedAt': noteDetail.createdAt?.toIso8601String(),
        'UpdatedAt': noteDetail.updatedAt?.toIso8601String(),
        'Content': noteDetail.content,
      });
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.close();
  }
}

Future postNoteReminderAsync(int noteId, NoteReminder noteReminder) async {
  var db = await openDatabase(dbName);
  try {
    await db.transaction((txn) async {
      await db.insert('NoteReminder', {
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
  } finally {
    db.close();
  }
}

Future<List<NoteHeader>> getNotesAsync({String category = category_all}) async {
  String getNotesQuery = category == category_all
      ? '''
  Select * from NoteHeader 
  '''
      : '''
  Select * from NoteHeader where CategoryID = ?
  ''';
  var db = await openDatabase(dbName);
  var results = category == category_all
      ? await db.rawQuery(getNotesQuery)
      : await db.rawQuery(getNotesQuery, [category]);

  try {
    return List.generate(results.length, (index) {
      return NoteHeader.fromJson(results[index]);
    });
  } finally {
    db.close();
  }
}

Future<NoteDetail?> getNoteAsync(String noteID) async {
  String getNoteQuery = 'Select * from NoteDetail where noteId = ?';
  var db = await openDatabase(dbName);

  try {
    var result = (await db.rawQuery(getNoteQuery, [noteID])).first;
    return NoteDetail.fromJson(result);
  } on StateError catch (e) {
    print('Unable to fetch note detail with note ID # $noteID ,$e');
    return NoteDetail();
  } finally {
    db.close();
  }
}

Future patchNoteAsync(NoteHeader note) async {
  DateTime updatedAt = DateTime.now();
  var db = await openDatabase(dbName);
  try {
    await db.transaction((txn) async {
      await db.update(
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
      await db.update(
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
  } finally {
    db.close();
  }
}

Future deleteNote(NoteHeader note) async {
  DateTime updatedAt = DateTime.now();
  var db = await openDatabase(dbName);
  try {
    await db.transaction((txn) async {
      await db.delete('NoteHeader', where: 'Id = ?', whereArgs: [note.id]);
      await db.delete('NoteDetail', where: 'NoteID = ?', whereArgs: [note.id]);
    });
  } catch (e) {
    throw Exception(e);
  } finally {
    db.close();
  }
}
