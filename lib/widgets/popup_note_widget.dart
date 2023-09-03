import 'package:flutter/material.dart';

class PopUpMenuNoteWidget extends StatefulWidget {
  final Widget notePageWidget;
  const PopUpMenuNoteWidget({required this.notePageWidget, super.key});

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => widget.notePageWidget));
                },
                icon: Icon(
                  Icons.edit_note,
                  color: Colors.black,
                  size: 20,
                ),
                label: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Edit Note'),
                )),
          ),
          SizedBox(
            width: double.infinity,
            height: maxMenuHeight / 2,
            child: TextButton.icon(
                onPressed: () {
                  setState(() {});
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
