import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/styling.dart';

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({super.key});

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TableCalendar(
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
                  color: Colors.yellow, // Set the background color to yellow
                  shape: BoxShape.circle, // Optional: Add rounded corners
                ),
                selectedTextStyle: TextStyle(
                  color: Colors.black, // Set the text color for selected date
                  fontWeight: FontWeight.bold, // Optional: Add font weight
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }),
          Container(
            height: 40,
            color: Colors.black,
          ),
          ScrollablePositionedList.builder(
              //physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemScrollController: categoryBarController,
              itemCount: noteCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPressStart: (details) {
                    Vibration.vibrate(duration: 100, amplitude: 50);
                    showDialog(
                        context: context,
                        builder: (context) => RemoveCategoryAlertBoxWidget(
                              category: noteCategories[selectedIndex],
                              layoutDataProvider: widget.layoutData,
                            ));
                  },
                  onTap: () {
                    var originalIndex = selectedIndex;
                    selectedIndex = index;
                    if (selectedIndex == noteCategories.length - 1) {
                      selectedIndex = originalIndex;
                      showDialog(
                          context: context,
                          builder: (context) => CategoryAlertBoxWidget(
                                layoutDataProvider: widget.layoutData,
                                categoryType: note_type,
                              ));
                    } else {
                      setState(() {
                        currentCategoryID = noteCategories[index].id!;
                        widget.layoutData
                            .setThemeStyle(noteCategories[index].colorId);
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: currentCategoryID == noteCategories[0].id
                          ? Border.all(
                              color: widget.layoutData.theme.Theme_Color_ROOT)
                          : Border.all(color: Category_BorderColor_DESELECTED),
                      color: currentCategoryID == noteCategories[index].id
                          ? Category_Color_SELECTED
                          : Category_Color_DESELECTED,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 10, top: 6, bottom: 6),
                      child: Text(noteCategories[index].name,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color:
                                  currentCategoryID == noteCategories[index].id
                                      ? Font_Color_Default
                                      : Font_Color_UNSELECTED,
                              fontSize: Font_Size_CONTENT,
                              fontFamily: Font_Family_LATO,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                );
              }),
        ],
      ),
    ));
  }
}
