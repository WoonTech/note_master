import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

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
    var db = await openDatabase(
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
    //cleanNoteTable(db);
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
        NoteID TEXT,
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
}

/*void addColumnToTable(Database database) async {
  await database.execute('ALTER TABLE NoteReminder ADD COLUMN NoteID TEXT');
}*/

void cleanNoteTable(Database database) async {
  await database.execute('Delete From NoteHeader');
  await database.execute('Delete From NoteDetail');
  await database.execute('Delete From NoteReminder');
}
