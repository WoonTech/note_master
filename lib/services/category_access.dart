import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/data_access.dart';
import '../models/category.dart';

Future postCategoryAsync(NoteCategory category) async {
  var db = (await database);
  try {
    return await db.transaction((txn) async {
      await txn.insert('Category', {
        'CreatedAt': category.createdAt.toIso8601String(),
        'UpdatedAt': category.updatedAt.toIso8601String(),
        'CategoryName': category.name.trim(),
        'Status': category.status,
        'Type': category.type,
      });
    });
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

Future<List<NoteCategory>> getCategoriesAsync() async{
  String getCategoriesQuery = 'Select * from Category'; 
  var db = (await database);
  var results = await db.rawQuery(getCategoriesQuery);
  try
  {
    return List.generate(results.length, (index)
    {
      return NoteCategory.fromJson(results[index]);
    });
  } catch(ex) {
    throw Exception(ex);
  }
}

Future patchCategoryAsync(NoteCategory category) async{
  DateTime updatedAt = DateTime.now();
  var db = (await database);
  try{
    await db.transaction((txn) async{
      await txn.update('Category', {
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
  }
}

Future deleteCategoryAsync(NoteCategory category) async{
  DateTime updatedAt = DateTime.now();
  var db = (await database);
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
  }
}
