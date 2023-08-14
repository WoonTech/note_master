import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

import '../constants/status.dart';
import '../models/category.dart';
import '../models/notedetail.dart';
import '../models/noteheader.dart';
import '../models/notereminder.dart';
import '../models/repetition.dart';

final Future<Database> database = SQLDataAccess().database;

class SQLDataAccess {
  String dbName = 'note_master_db.db';

  // Singleton pattern
  static final SQLDataAccess _databaseService = SQLDataAccess._internal();
  factory SQLDataAccess() => _databaseService;
  SQLDataAccess._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      var db = await initialiseDBAsync();
      _database = db;
    }
    return _database!;
  }

  Future<Database> initialiseDBAsync() async {
    //Create Note Header
    final directory = await getDatabasesPath();
    String path = join(directory, dbName);
    String createNoteHeaderQuery = getCreateNoteHeaderQuery();
    String createNoteDetailQuery = getCreateNoteDetailQuery();
    String createCategoryQuery = getCreateCategoryQuery();
    String createNoteReminderQuery = getCreateNoteReminderQuery();
    String createReminderRepetitionQuery = getCreateReminderRepetitionQuery();
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.transaction((txn) async {
          await txn.execute(createNoteHeaderQuery);
          await txn.execute(createNoteDetailQuery);
          await txn.execute(createCategoryQuery);
          await txn.execute(createNoteReminderQuery);
          await txn.execute(createReminderRepetitionQuery);
        });
      },
    );
    //await db.execute(createCategoryQuery);
    //addColumnToTable(db);
    //cleanNoteTable(db);
    //cleanCategoryTable(db);
    return db;
  }

  String getCreateNoteHeaderQuery() {
    return '''
    CREATE TABLE NoteHeader (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      CreatedAt TEXT,
      UpdatedAt TEXT,
      Title TEXT,
      IsPinned TEXT,
      Status TEXT,
      CategoryID TEXT
    )
    ''';
  }

  String getCreateNoteDetailQuery() {
    return '''
    CREATE TABLE NoteDetail (
      ID INTEGER PRIMARY KEY,
      NoteID TEXT,
      Content TEXT
    )
    ''';
  }

  String getCreateCategoryQuery() {
    return '''
      CREATE TABLE NoteCategory (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        NoteID TEXT,
        CreatedAt TEXT,
        UpdatedAt TEXT,
        CategoryName TEXT,
        Status TEXT,
        Type TEXT,
        ColorID TEXT
      )
      ''';
  }

  String getCreateNoteReminderQuery() {
    return '''
      CREATE TABLE NoteReminder (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        NoteID TEXT,
        RemindedAt TEXT,
        Repetition TEXT,
        NotificationText TEXT
      )
    ''';
  }

  String getCreateReminderRepetitionQuery() {
    return '''
      CREATE TABLE ReminderRepetition (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        RepetitionText TEXT
      )
    ''';
  }

  /*String getCreateNoteCategoryQuery(){
    return '''
      CREATE TABLE Note_Category (
        ID INTEGER PRIMARY KEY,
        CreatedAt TEXT,
        UpdatedAt TEXT,
        NoteID TEXT,
        CategoryID TEXT,
      )
    ''';  
  }*/
}

/*void addColumnToTable(Database database) async {
  await database.execute('ALTER TABLE NoteReminder ADD COLUMN NoteID TEXT');
}*/

void addColumnToTable(Database database) async {
  await database.execute('ALTER TABLE NoteReminder ADD COLUMN RemindedAt TEXT');
}

void cleanNoteTable(Database database) async {
  await database.execute('Delete From NoteHeader');
  await database.execute('Delete From NoteDetail');
  await database.execute('Delete From NoteReminder');
}

void cleanCategoryTable(Database db) async {
  await db.execute("Delete From Category");
}

Future<int> postCategoryAsync(NoteCategory category) async {
  var db = (await database);
  int categoryId = 0;
  try {
    await db.transaction((txn) async {
      categoryId = await txn.insert('NoteCategory', {
        'CreatedAt': category.createdAt.toIso8601String(),
        'UpdatedAt': category.updatedAt.toIso8601String(),
        'CategoryName': category.name.trim(),
        'Status': category.status,
        'Type': category.type,
        'ColorID': category.colorId,
      });
    });
    return categoryId;
  } catch (e) {
    throw Exception(e);
  }
}

/*List<NMCategory> getCategories(){
  List<NMCategory> categories = <NMCategory>[];
  getCategoriesAsync().then((value) {
    categories = value;
  });
  return categories;
}*/

Future<List<NoteCategory>> getCategoriesAsync() async {
  String getCategoriesQuery = 'Select * from NoteCategory  where Status = ?';
  var db = (await database);
  var results = await db.rawQuery(getCategoriesQuery, [activeStatus]);
  print(results.toString());
  try {
    return List.generate(results.length, (index) {
      return NoteCategory.fromJson(results[index]);
    });
  } catch (e) {
    print(e.toString());
    throw Exception(e.toString());
  }
}

Future patchCategoryAsync(NoteCategory category) async {
  DateTime updatedAt = DateTime.now();
  var db = (await database);
  try {
    await db.transaction((txn) async {
      await txn.update(
          'NoteCategory',
          {
            'UpdatedAt': updatedAt.toIso8601String(),
            'CategoryName': category.name.trim(),
            'Status': category.status,
            'Type': category.type,
            'ColorID': category.colorId
          },
          where: 'ID = ?',
          whereArgs: [category.id]);
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future deleteCategoryAsync(NoteCategory category) async {
  DateTime updatedAt = DateTime.now();
  var db = (await database);
  try {
    await db.transaction((txn) async {
      await txn
          .update('NoteCategory',{ 'Status': inactiveStatus}, where: 'ID = ?', whereArgs: [category.id]);
      await txn.update(
          'NoteHeader',
          {
            'UpdatedAt': updatedAt.toIso8601String(),
            'CategoryID': category_default_ID,
          },
          where: 'CategoryID = ?',
          whereArgs: [category.id]);
    });
  } catch (e) {
    throw Exception(e);
  }
}

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
        'CategoryID': noteHeader.categoryId
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
        'RemindedAt': noteReminder.remindedAt.toIso8601String(),
        'Repetition': noteReminder.repetitionId,
        'NotificationText': noteReminder.notificationText
      });
    });
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<NoteHeader>> getNotesAsync(
    {int category = category_default_ID}) async {
  String getNotesQuery = category == category_default_ID
      ? '''
  Select NoteHeader.*, 
  NoteDetail.ID as DetailID, NoteDetail.Content, 
  NoteReminder.ID as ReminderID, NoteReminder.RemindedAt as RemindedAt, NoteReminder.Repetition as RepetitionID, NoteReminder.NotificationText as NotificationText from NoteHeader 
  LEFT JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID
  LEFT JOIN NoteReminder ON NoteHeader.ID = NoteReminder.NoteID
  '''
      : '''
  Select NoteHeader.*,
  NoteDetail.ID as DetailID, NoteDetail.Content, 
  NoteReminder.ID as ReminderID, NoteReminder.RemindedAt as RemindedAt, NoteReminder.Repetition as RepetitionID, NoteReminder.NotificationText as NotificationText from NoteHeader 
  LEFT JOIN NoteDetail ON NoteHeader.ID = NoteDetail.NoteID
  LEFT JOIN NoteReminder ON NoteHeader.ID = NoteReminder.NoteID
  where NoteHeader.CategoryID = ?
  ''';

  var db = (await database);
  var results = category == category_default_ID
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
            'CategoryID': note.categoryId
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
            'RemindedAt': note.noteReminder?.remindedAt.toIso8601String(),
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

Future<List<NoteRepetition>> getRepetitionsAsync() async {
  String getRepetitionsQuery = 'Select * from ReminderRepetition';
  var db = (await database);
  var results = await db.rawQuery(getRepetitionsQuery);
  try {
    return List.generate(results.length, (index) {
      return NoteRepetition.fromJson(results[index]);
    });
  } catch (ex) {
    throw Exception(ex);
  }
}

Future postRepetitionsAsync(List<NoteRepetition> repetitions) async {
  var db = (await database);
  for (var repetition in repetitions) {
    try {
      await db.transaction((txn) async {
        await txn.insert('ReminderRepetition', {
          'RepetitionText': repetition.repetitionText,
        });
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
