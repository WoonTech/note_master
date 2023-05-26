import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String dbName = 'note_master_db.db';


Future<bool> dbExists() async{
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, dbName);
  return File(path).existsSync();
}

Future postDBs() async{
  bool isDBExisted = await dbExists();
  if (!isDBExisted){
    await postDBAsync();
  }
}

Future postDBAsync() async{
  //Create Note Header
  String createNoteHeaderQuery = getCreateNoteHeaderQuery();
  String createNoteDetailQuery = getCreateNoteDetailQuery();
  String createCategoryQuery = getCreateCategoryQuery();
  //String createNoteCategoryQuery = getCreateNoteCategoryQuery();
  Database db = await openDatabase(dbName);
  await db.transaction((txn) async {
    await txn.execute(createNoteHeaderQuery);
    await txn.execute(createNoteDetailQuery);
    await txn.execute(createCategoryQuery);
    //await txn.execute(createNoteCategoryQuery);

  });
}

String getCreateNoteHeaderQuery(){
  return '''
  CREATE TABLE NoteHeader (
    ID INTEGER PRIMARY KEY,
    CreatedAt TEXT,
    UpdatedAt TEXT,
    RemindedAt TEXT,
    Title TEXT,
    IsPinned TEXT,
    Status TEXT,
    CategoryID TEXT,
  )
''';
}

String getCreateNoteDetailQuery(){
  return '''
  CREATE TABLE NoteHeader (
    ID INTEGER PRIMARY KEY,
    NoteID TEXT,
    CreatedAt TEXT,
    UpdatedAt TEXT,
    Content TEXT,
  )
''';
}

String getCreateCategoryQuery(){
  return '''
    CREATE TABLE Category (
      ID INTEGER PRIMARY KEY,
      CreatedAt TEXT,
      UpdatedAt TEXT,
      CategoryName TEXT,
      Status TEXT,
      Type TEXT,
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