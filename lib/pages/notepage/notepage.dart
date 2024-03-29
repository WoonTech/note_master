import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:note_master/widgets/category_widget.dart';
import 'package:note_master/main.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/layout.dart';
import 'package:note_master/models/notedetail.dart';
import 'package:note_master/models/noteheader.dart';
import 'package:note_master/models/notereminder.dart';
import 'package:note_master/models/styling.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/data_access.dart';
import '../../widgets/reminder.dart';
import '../../constants/status.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/repetition.dart';

class NotePage extends StatefulWidget {
  NoteHeader? cardNote;
  LayoutDataProvider? layoutData;
  NotePage({this.cardNote, this.layoutData, key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isReminderSet = false;
  int categorySelectedValue = 1;
  DateTime createdAt = DateTime.now();
  TextEditingController contentTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    currentNote = null;
    createdAt = DateTime.now();
    initializeCurrentNote();
  }

  void initializeCurrentNote() {
    if (widget.cardNote != null) {
      currentNote = widget.cardNote;
      isReminderSet = isReminderOver(widget.cardNote!.noteReminder!.remindedAt);
      categorySelectedValue = widget.cardNote!.categoryId ?? 1;
      titleTextEditingController.text = widget.cardNote!.title;
      contentTextEditingController.text = widget.cardNote!.noteDetail!.content;
    } else {
      currentNote =
          NoteHeader(createdAt: createdAt, updatedAt: createdAt, title: '');
      currentNote!.noteDetail = NoteDetail(content: "");
      currentNote!.noteReminder = NoteReminder(
          remindedAt: minReminderAt,
          repetitionId: noteRepetitions.first.id!,
          notificationText: "");
      setState(() {
        currentNote;
      });
    }
  }

  void togglePinned() {
    setState(() {
      currentNote!.isPinned = !currentNote!.isPinned;
    });
  }

  void toggleReminder(DateTime? dateTime) {
    if (dateTime != null) {
      setState(() {
        isReminderSet = !isReminderSet;
      });
    }
  }

  bool isReminderOver(DateTime? reminderTime) {
    return reminderTime!.difference(createdAt) > Duration.zero;
  }

  String updateTitle(String title) {
    List<String> words = title.split(RegExp(r'[\s\n]+'));
    if (words.length >= 2) {
      return words.take(2).join(' ');
    } else if (words.isNotEmpty) {
      return words.first;
    }
    return '';
  }

  bool IsContentAndTitleEmpty(String title, String content) {
    if (title.isNotEmpty) {
      return false;
    }
    if (content.isNotEmpty) {
      return false;
    }
    return true;
  }

  NoteHeader ToNote() {
    var noteHeader = NoteHeader(
        id: currentNote?.id,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
        title: titleTextEditingController.text,
        isPinned: currentNote!.isPinned,
        status: currentNote?.status ?? activeStatus,
        categoryId: currentNote?.categoryId ?? category_default_ID);
    var noteDetail = NoteDetail(content: contentTextEditingController.text);
    var noteReminder = NoteReminder(
        remindedAt:
            currentNote?.noteReminder?.remindedAt ?? DateTime.utc(1999, 1, 1),
        repetitionId: currentNote?.noteReminder?.repetitionId ??
            noteRepetitions.first.id!,
        notificationText: currentNote?.noteReminder?.notificationText ?? '');
    noteHeader.noteReminder = noteReminder;
    noteHeader.noteDetail = noteDetail;
    return noteHeader;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0, opacity: 10),
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.4,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.draw),
              backgroundColor: Colors.white,
              label: 'Writing',
              labelStyle: TextStyle(
                  fontFamily: Font_Family_LATO,
                  fontSize: Font_Size_DIALOG,
                  color: Font_Color_Default),
              onTap: () {
                // Handle add action here
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.image),
              backgroundColor: Colors.white,
              label: 'Assets',
              labelStyle: TextStyle(
                  fontFamily: Font_Family_LATO,
                  fontSize: Font_Size_DIALOG,
                  color: Font_Color_Default),
              onTap: () {
                // Handle edit action here
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.text_format),
              backgroundColor: Colors.white,
              label: 'Style',
              labelStyle: TextStyle(
                  fontFamily: Font_Family_LATO,
                  fontSize: Font_Size_DIALOG,
                  color: Font_Color_Default),
              onTap: () {
                // Handle delete action here
              },
            ),
          ],
        ),
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
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 5),
                child: PopupMenuButton(
                  icon: Icon(
                    Icons.book,
                    color: subDomainColors[noteCategories
                        .where((element) => element.id == categorySelectedValue)
                        .first
                        .colorId],
                  ),
                  onSelected: (newValue) {
                    setState(() {
                      currentNote?.categoryId = newValue;
                      categorySelectedValue = newValue;
                      tmpNoteCategory = noteCategories
                          .where((element) => element.id == newValue)
                          .first;
                    });
                  },
                  itemBuilder: (context) => noteCategories
                      .where((element) => element.type == note_type)
                      .map((category) {
                    return PopupMenuItem(
                        value: category.id,
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: category.name == category_default_selection
                                  ? Colors.transparent
                                  : subDomainColors[category.colorId],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(category.name)
                          ],
                        ));
                  }).toList(),
                )),
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    togglePinned();
                    //Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.star,
                    color: currentNote!.isPinned
                        ? Icon_Color_Pinned
                        : Icon_Active_Color,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ReminderAlertBoxWidget();
                        });
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: isReminderOver(currentNote!.noteReminder!.remindedAt)
                        ? const Color.fromRGBO(37, 87, 218, 1)
                        : Icon_Active_Color,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    var titleText = titleTextEditingController.text;
                    if (titleText.isEmpty) {
                      titleTextEditingController.text =
                          updateTitle(contentTextEditingController.text);
                    }
                    widget.cardNote = ToNote();
                    saveNoteAsync(widget.cardNote!)
                        .then((value) => widget.cardNote = value)
                        .whenComplete(() {
                      setState(() {
                        widget.layoutData!
                            .addLatestNoteToList(widget.cardNote!);
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                      Fluttertoast.showToast(msg: "Note saved successfully!");
                    });
                  },
                  icon: Icon(Icons.check,
                      color: IsContentAndTitleEmpty(
                              titleTextEditingController.text,
                              contentTextEditingController.text)
                          ? Icon_Inactive_Color
                          : Icon_Active_Color)),
            ),
          ],
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                color: Notepad_Color,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: titleTextEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Title',
                                hintStyle: TextStyle(
                                    color: Font_Color_DETAILS,
                                    fontSize: Font_Size_TITLE,
                                    fontFamily: Font_Family_LATO,
                                    fontWeight: FontWeight.bold),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontFamily: Font_Family_LATO,
                                  fontSize: Font_Size_TITLE,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          /*itemBuilder: (context) => noteCategories
                      .where((element) => element.type == note_type)
                      .map((category) {
                    return PopupMenuItem(
                        value: category.id,
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: category.name == category_default_selection
                                  ? Colors.transparent
                                  : subDomainColors[category.colorId],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(category.name)
                          ],
                        ));
                  }).toList(),*/

                          DropdownButton(
                            items: noteCategories
                                .where((element) => element.type == note_type)
                                .map<DropdownMenuItem<NoteCategory>>(
                                    (NoteCategory value) {
                              return DropdownMenuItem<NoteCategory>(
                                value: value,
                                child: Text(
                                  value.name,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (NoteCategory? value) {
                              setState(() {
                                //_chosenValue = value;
                              });
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        formattedDate.format(currentNote!.createdAt),
                        style: TextStyle(
                            fontFamily: Font_Family_LATO,
                            fontSize: Font_Size_DIALOG,
                            color: Font_Color_DETAILS),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Expanded(
                          child: TextField(
                        maxLines: null,
                        autofocus: contentTextEditingController.text == ""
                            ? true
                            : false,
                        controller: contentTextEditingController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))));
  }
}
