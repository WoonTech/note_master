import 'package:flutter/material.dart';

class NoteApp extends StatefulWidget {
  @override
  _NoteAppState createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  List<String> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNoteDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showNoteDialog(BuildContext context) async {
    String note = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Note'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Write your note here...'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('Save');
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (note != null && note.isNotEmpty) {
      setState(() {
        notes.add(note);
      });
    }
  }
}