import 'package:flutter/material.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/note_detail.dart';
import 'package:note_master/models/note_header.dart';
import 'package:note_master/models/note_reminder.dart';
import 'package:note_master/models/styling.dart';
import 'package:note_master/services/note_access.dart';
import 'package:intl/intl.dart';
import '../components/reminder.dart';
import '../constants/status.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isNotePinned = false;
  bool isReminderSet = false;
  DateTime createdAt = DateTime.now();
  late String contentTitle;
  late DateTime updatedAt;
  late bool isPinned;
  late String status;
  String categoryId = category_default;
  TextEditingController contentTextEditingController = TextEditingController();
  TextEditingController titleTextEditingController = TextEditingController();

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
                  //togglePinned();
                  //Navigator.pop(context);
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
                  var noteHeader = NoteHeader(
                    createdAt: createdAt,
                    updatedAt: updatedAt,
                    title: titleTextEditingController.text,
                    isPinned: isNotePinned,
                    status: activeStatus,
                    category: categoryId
                  );
                  var noteDetail = NoteDetail(
                      createdAt: createdAt,
                      updatedAt: updatedAt,
                      content: contentTextEditingController.text);
                  noteHeader.noteDetail = noteDetail;
                  saveNoteAsync(noteHeader);
                  FocusScope.of(context).requestFocus(FocusNode());
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
                  DateFormat('d, MMM dd h:mm a').format(createdAt),
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
          )
        )
      )
    );
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
      autofocus: true,
      controller: widget.textEditingController,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
