import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = 'note_master_db.db';
Future<bool> dbExists(String path) async {
  return File(path).existsSync();
}

Future ensureDBExisted() async {
  final directory = await getDatabasesPath();
  String path = join(directory, dbName);
  bool isDBExisted = await dbExists(path);
  if (!isDBExisted) {
    await initialiseDBAsync();
  }
}

Future<Database> initialiseDBAsync() async{
  //Create Note Header
  final directory = await getDatabasesPath();
  String path = join(directory, dbName);
  String createNoteHeaderQuery = getCreateNoteHeaderQuery();
  String createNoteDetailQuery = getCreateNoteDetailQuery();
  String createCategoryQuery = getCreateCategoryQuery();
  String createNoteReminderQuery = getCreateNoteReminderQuery();
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      return await db.transaction((txn) async {
        await txn.execute(createNoteHeaderQuery);
        await txn.execute(createNoteDetailQuery);
        await txn.execute(createCategoryQuery);
        await txn.execute(createNoteReminderQuery);
      });
    },
  );
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
    CreatedAt TEXT,
    UpdatedAt TEXT,
    Content TEXT
  )
  ''';
}

String getCreateCategoryQuery() {
  return '''
    CREATE TABLE Category (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      NoteID TEXT,
      CreatedAt TEXT,
      UpdatedAt TEXT,
      CategoryName TEXT,
      Status TEXT,
      Type TEXT
    )
    ''';
}

String getCreateNoteReminderQuery() {
  return '''
    CREATE TABLE NoteReminder (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      CreatedAt TEXT,
      UpdatedAt TEXT,
      ReminderAt TEXT,
      Repetition TEXT,
      NotificationText TEXT
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