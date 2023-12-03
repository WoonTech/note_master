import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_master/models/noteheader.dart';
import 'package:note_master/utils/date_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/layout.dart';
import '../../models/styling.dart';
import '../../widgets/notecard_widget.dart';

class Calendar_Page extends StatefulWidget {
  final LayoutDataProvider layoutData;
  final double contentHeight;
  final TextEditingController controller;
  const Calendar_Page(
      {super.key,
      required this.layoutData,
      required this.contentHeight,
      required this.controller});

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var correspondingNotes = notes.values.where((element) =>
        element.noteReminder!.remindedAt.compareDate(_selectedDay));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Notepad_Color,
          shadowColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsets.only(left: 20),
            child: IconButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await Future.delayed(const Duration(milliseconds: 100));
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Icon_Active_Color,
                )),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TableCalendar(
                  headerVisible: false,
                  headerStyle: HeaderStyle(
                      decoration: BoxDecoration(
                        color: Notepad_Color,
                      ),
                      titleCentered: true,
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(
                        Icons.arrow_back_ios,
                        color: Icon_Active_Color,
                      ),
                      rightChevronIcon: Icon(
                        Icons.arrow_forward_ios,
                        color: Icon_Active_Color,
                      )),
                  calendarFormat: _calendarFormat,
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2050),
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(_selectedDay, date);
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color:
                          Colors.yellow, // Set the background color to yellow
                      shape: BoxShape.circle, // Optional: Add rounded corners
                    ),
                    selectedTextStyle: TextStyle(
                      color:
                          Colors.black, // Set the text color for selected date
                      fontWeight: FontWeight.bold, // Optional: Add font weight
                    ),
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }),
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: correspondingNotes.length,
                    itemBuilder: (context, index) {
                      return NoteCardHolderWidget(
                        note: correspondingNotes.elementAt(index),
                        currentTheme: widget.layoutData,
                        contentHeight: widget.contentHeight,
                        isHideContent: false,
                        index: index,
                        textEditingController: widget.controller,
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
