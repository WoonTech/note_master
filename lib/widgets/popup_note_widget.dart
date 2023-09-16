import 'package:flutter/material.dart';

import '../models/layout.dart';
import '../models/noteheader.dart';
import '../services/data_access.dart';

class PopUpMenuNoteWidget extends StatefulWidget {
  final Widget notePageWidget;
  final NoteHeader note;
  final LayoutDataProvider layoutData;
  const PopUpMenuNoteWidget(
      {required this.notePageWidget,
      required this.note,
      required this.layoutData,
      super.key});

  @override
  State<PopUpMenuNoteWidget> createState() => _PopUpMenuNoteWidgetState();
}

class _PopUpMenuNoteWidgetState extends State<PopUpMenuNoteWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final maxMenuWidth = size.width * 0.42;
    final maxMenuHeight = size.height * 0.1;
    return Container(
      width: maxMenuWidth,
      height: maxMenuHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: maxMenuHeight / 2,
            child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => widget.notePageWidget));
                },
                icon: const Icon(
                  Icons.edit_note,
                  color: Colors.black,
                  size: 20,
                ),
                label: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Edit Note'),
                )),
          ),
          SizedBox(
            width: double.infinity,
            height: maxMenuHeight / 2,
            child: TextButton.icon(
                onPressed: () {
                  deleteNoteAsync(widget.note.id!).whenComplete(() {
                    setState(() {
                      widget.layoutData
                          .removeCurrentNoteToList(widget.note.id!);
                      Navigator.pop(context);
                    });
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                  size: 20,
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Delete Note'),
                )),
          ),
        ],
      ),
    );
  }
}
