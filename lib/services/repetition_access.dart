import 'package:note_master/models/repetition.dart';

import '../utils/data_access.dart';

Future<List<NoteRepetition>> getRepetitionsAsync() async{
  String getRepetitionsQuery = 'Select * from ReminderRepetition'; 
  var db = (await database);
  var results = await db.rawQuery(getRepetitionsQuery);
  try
  {
    return List.generate(results.length, (index)
    {
      return NoteRepetition.fromJson(results[index]);
    });
  } catch(ex) {
    throw Exception(ex);
  }
}

Future postRepetitionsAsync(List<NoteRepetition> repetitions) async {
  var db = (await database);
  for(var repetition in repetitions){
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