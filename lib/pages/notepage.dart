import 'package:flutter/material.dart';
import 'package:note_master/components/category.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/layout.dart';
import 'package:note_master/models/notedetail.dart';
import 'package:note_master/models/noteheader.dart';
import 'package:note_master/models/notereminder.dart';
import 'package:note_master/models/styling.dart';
import 'package:note_master/services/note_access.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../components/reminder.dart';
import '../constants/status.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotePage extends StatefulWidget {
  NoteHeader? currentNote;

  NotePage({this.currentNote, super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isNotePinned = false;
  bool isReminderSet = false;
  DateTime createdAt = DateTime.now();
  late String contentTitle;
  late DateTime updatedAt;
  DateTime? reminderAt;
  int repetition = 0;
  String notificationText = '';
  late String status;
  String categoryId = category_default;
  TextEditingController contentTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.currentNote != null) {
      isNotePinned = widget.currentNote!.isPinned;
      contentTitle = widget.currentNote!.title;
      createdAt = widget.currentNote!.createdAt;
      status = widget.currentNote!.status;
      categoryId = widget.currentNote!.category;
      titleTextEditingController.text = widget.currentNote!.title;
      contentTextEditingController.text =
          widget.currentNote!.noteDetail!.content;
    }
  }

  void togglePinned() {
    setState(() {
      isNotePinned = !isNotePinned;
    });
  }

  void toggleReminder(DateTime? dateTime) {
    if (dateTime != null) {
      setState(() {
        isReminderSet = !isReminderSet;
      });
    }
  }

  String updateTitle(String title) {
    List<String> words = title.split(' ');
    if (words.length >= 2) {
      return words.take(2).join(' ');
    } else if (words.isNotEmpty) {
      return words.first;
    }
    return '';
  }

  NoteHeader ToNote() {
    var noteHeader = NoteHeader(
        id: widget.currentNote != null ? widget.currentNote!.id : null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        title: titleTextEditingController.text,
        isPinned: isNotePinned,
        status: activeStatus,
        category: categoryId);
    var noteDetail = NoteDetail(content: contentTextEditingController.text);
    var noteReminder = NoteReminder(
        remindedAt: reminderAt ?? DateTime.utc(1999, 1, 1),
        repetition: repetition,
        notificationText: notificationText);
    noteHeader.noteReminder = noteReminder;
    noteHeader.noteDetail = noteDetail;
    return noteHeader;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Notepad_Color,
          shadowColor: Colors.transparent,
          leading: Container(
            margin: const EdgeInsets.only(left: 20),
            child: IconButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: NotepadIcon_Color,
                )),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CategoryAlertBoxWidget();
                        });
                  },
                  icon: Icon(
                    Icons.book,
                    color: NotepadIcon_Color,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    togglePinned();
                    //Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.star,
                    color: isNotePinned
                        ? const Color.fromRGBO(252, 196, 25, 1)
                        : NotepadIcon_Color,
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
                    color: isReminderSet
                        ? const Color.fromRGBO(37, 87, 218, 1)
                        : NotepadIcon_Color,
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    updatedAt = DateTime.now();
                    var titleText = titleTextEditingController.text;
                    if (titleText.isEmpty) {
                      titleTextEditingController.text =
                          updateTitle(contentTextEditingController.text);
                    }
                    widget.currentNote = ToNote();
                    saveNoteAsync(widget.currentNote!)
                        .then((value) => widget.currentNote = value)
                        .whenComplete(() {
                      setState(() {
                        Provider.of<LayoutDataProvider>(context, listen: false)
                            .addLatestNoteToList(widget.currentNote!);
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                      Fluttertoast.showToast(msg: "Note saved successfully!");
                    });
                  },
                  icon: Icon(
                    Icons.check,
                    color: NotepadIcon_Color,
                  )),
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
                      TextField(
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
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        formattedDate.format(createdAt),
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
                        child: NotePad(
                          textEditingController: contentTextEditingController,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ))));
  }
}

class NotePad extends StatefulWidget {
  final TextEditingController textEditingController;
  const NotePad({required this.textEditingController, super.key});

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      autofocus: widget.textEditingController.text == "" ? true : false,
      controller: widget.textEditingController,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
