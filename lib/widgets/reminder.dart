import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_master/models/layout.dart';
import 'package:note_master/models/notereminder.dart';
import 'package:note_master/models/repetition.dart';
import 'package:note_master/utils/date_utils.dart';

import '../models/styling.dart';
import 'button_bar_widget.dart';
import 'datepicker.dart';
import 'repetition_widget.dart';

late NoteReminder tmpNoteReminder;

class NotificationWidget extends StatefulWidget {
  final NoteReminder noteReminder;
  const NotificationWidget({required this.noteReminder, super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  void dateConverter() {}

  @override
  Widget build(BuildContext context) {
    var reminderAt = widget.noteReminder.remindedAt.difference(DateTime.now());
    return Text(
      reminderAt > Duration.zero
          ? 'reminder: ${reminderAt.toString().toValidDuration(reminderAt)}'
          : '',
      style: TextStyle(
        color: Font_Color_SUBDOMAIN,
        fontSize: Font_Size_CONTENT,
        fontFamily: Font_Family_LATO,
      ),
    );
  }
}

class ReminderAlertBoxWidget extends StatefulWidget {
  const ReminderAlertBoxWidget({super.key});

  @override
  State<ReminderAlertBoxWidget> createState() => _ReminderAlertBoxWidgetState();
}

class _ReminderAlertBoxWidgetState extends State<ReminderAlertBoxWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitializeReminder();
  }

  Future<void> InitializeReminder() async {
    tmpNoteReminder = NoteReminder(
        remindedAt: minReminderAt,
        repetitionId: noteRepetitions.first.id!,
        notificationText: '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      title: Center(child: Text(
        'Set Reminder',
        style: TextStyle(
            color: Font_Color_Default,
            fontFamily: Font_Family_LATO,
            fontSize: Font_Size_HEADER,
            fontWeight: FontWeight.w500),
      ),), 
      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const DateTimeFieldWidget(),
          const SizedBox(
            height: 5,
          ),
          DropDownFieldWidget(
            noteRepetitions: noteRepetitions,
          ),
          const SizedBox(
            height: 5,
          ),
          const ReminderTextFieldWidget(),
        ],
      ),
      actions: [ButtonBarWidget(noteReminder: tmpNoteReminder)],
    );
  }
}

class ReminderTextFieldWidget extends StatefulWidget {
  const ReminderTextFieldWidget({super.key});

  @override
  State<ReminderTextFieldWidget> createState() =>
      _ReminderTextFieldWidgetState();
}

class _ReminderTextFieldWidgetState extends State<ReminderTextFieldWidget> {
  TextEditingController controller =
      TextEditingController(text: currentNote!.noteReminder!.notificationText);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 34,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color.fromRGBO(245, 245, 245, 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: const Icon(
                  Icons.edit_note,
                  color: Colors.black,
                  size: 20,
                )),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    tmpNoteReminder.notificationText = value;
                  });
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(right: 15, bottom: 15),
                    hintText: 'Notification text',
                    border: InputBorder.none),
                //focusNode: _focusNode,
                controller: controller,
                style: TextStyle(
                  fontSize: Font_Size_DIALOG,
                  fontFamily: Font_Family_LATO,
                ),
              ),
            ),
          ],
        ));
  }
}
