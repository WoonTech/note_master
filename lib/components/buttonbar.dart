import 'package:flutter/material.dart';
import 'package:note_master/models/layout.dart';

import '../models/notereminder.dart';
import '../models/styling.dart';

class ButtonBarWidget extends StatefulWidget {
  NoteReminder? noteReminder;
  ButtonBarWidget({this.noteReminder, super.key});

  @override
  State<ButtonBarWidget> createState() => _ButtonBarWidgetState();
}

class _ButtonBarWidgetState extends State<ButtonBarWidget> {

  bool isReminderOver(DateTime? reminderTime){
    return reminderTime!.difference(DateTime.now()) > Duration.zero;
  }

  void toggleReminder(DateTime? reminderAt) {
    if (isReminderOver(reminderAt)) {
      setState(() {
        currentNote!.noteReminder!.notificationText = widget.noteReminder!.notificationText;
        currentNote!.noteReminder!.remindedAt = widget.noteReminder!.remindedAt;
        currentNote!.noteReminder!.repetitionId = widget.noteReminder!.repetitionId;
      });
    }
  }
  void resetReminder(NoteReminder noteReminder){
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      layoutBehavior: ButtonBarLayoutBehavior.constrained,
      children: <Widget>[
        TextButton(
          onPressed: () => {
            Navigator.of(context).pop()
          },
          child: Text(
            'CANCEL',
            style: TextStyle(
              fontFamily: Font_Family_LATO,
              fontSize: Font_Size_DIALOG,
              color: Theme_Color_SYSTEM,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            toggleReminder(widget.noteReminder!.remindedAt);
            Navigator.of(context).pop();
          },
          child: Text(
            'DONE',
            style: TextStyle(
              fontFamily: Font_Family_LATO,
              fontSize: Font_Size_DIALOG,
              color: Theme_Color_SYSTEM,
            ),
          ),
        ),
      ],
    );
  ;
  }
}
