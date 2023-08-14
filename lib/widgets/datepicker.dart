import 'package:flutter/material.dart';
import 'package:note_master/widgets/reminder.dart';
import 'package:note_master/models/layout.dart';
import 'package:intl/intl.dart';
import 'package:note_master/models/notereminder.dart';
import '../models/styling.dart';

class DateTimeFieldWidget extends StatefulWidget {
  const DateTimeFieldWidget({super.key});

  @override
  State<DateTimeFieldWidget> createState() => _DateTimeFieldWidgetState();
}

class _DateTimeFieldWidgetState extends State<DateTimeFieldWidget> {
  void SetReminder(DateTime? dateTime) {
    setState(() {
      tmpNoteReminder.remindedAt = dateTime!;
    });
  }

  bool isReminderOver(DateTime? reminderTime) {
    return reminderTime!.difference(DateTime.now()) <= Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 34,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: const Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                  size: 20,
                )),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.only(left: 0),
                    alignment: Alignment.centerLeft,
                    enableFeedback: false),
                onPressed: () {
                  showDateTimePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  ).then((value) => SetReminder(value));
                },
                child: Text(
                  tmpNoteReminder.remindedAt != minReminderAt
                      ? formattedDate.format(tmpNoteReminder.remindedAt)
                      : isReminderOver(currentNote!.noteReminder!.remindedAt)
                          ? "Pick a date time"
                          : formattedDate
                              .format(currentNote!.noteReminder!.remindedAt),
                  style: TextStyle(
                      fontFamily: Font_Family_LATO,
                      fontSize: Font_Size_DIALOG,
                      color: Font_Color_Default,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ));
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(selectedDate),
  );

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}
