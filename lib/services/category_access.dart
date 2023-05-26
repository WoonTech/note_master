import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/data_access.dart';
import '../models/category.dart';

Future postCategoryAsync(NMCategory category) async {
  
}

Future<List<NMCategory>> getCategoriesAsync() async{
  String getCategoriesQuery = 'Select * from NoteHeader'; 
  var db = await openDatabase(dbName);
  var results = await db.rawQuery(getCategoriesQuery);
  try
  {
    return List.generate(results.length, (index)
    {
      return NMCategory.fromJson(results[index]);
    });
  } finally {
    db.close();
  }
}

Future patchCategoryAsync(NMCategory category) async{
  DateTime updatedAt = DateTime.now();
  var db = await openDatabase(dbName);
  try{
    await db.transaction((txn) async{
      await db.update('Category', {
        'UpdatedAt':updatedAt.toIso8601String(),
        'CategoryName':category.name.trim(),
        'Status': category.status,
        'Type': category.type
        },
        where: 'ID = ?',
        whereArgs: [category.id]
        );
      });
  }catch (e) {
    throw Exception(e);
  } finally {
    db.close();
  }
}

Future deleteCategoryAsync(NMCategory category) async{
  DateTime updatedAt = DateTime.now();
  var db = await openDatabase(dbName);
  try{

    await db.transaction((txn) async{
      await db.delete('Category',
        where: 'ID = ?',
        whereArgs: [category.id]
        );
      await db.update('NoteHeader',
        {
          'UpdatedAt': updatedAt.toIso8601String(),
          'CategoryID': '',
        },
        where: 'CategoryID = ?',
        whereArgs: [category.id]
        );
      });

  }catch (e) {

    throw Exception(e);

  } finally {

    db.close();
  }
}
