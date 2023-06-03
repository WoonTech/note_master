import 'package:flutter/material.dart';
import 'package:note_master/components/reminder.dart';
import 'package:note_master/models/note_header.dart';
import 'package:intl/intl.dart';
import '../models/styling.dart';
import '../services/note_access.dart';

class CardWidget extends StatefulWidget {
  final CurrentTheme currentTheme;
  final double contentHeight;
  final NoteHeader note;
  const CardWidget(
      {required this.note, required this.currentTheme, required this.contentHeight, super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  void initState() {
    super.initState();
  }
    //getNotesAsync(currentTheme.theme.Category);
  

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: widget.currentTheme.theme.Theme_Color_ROOT,
                            width: 7))),
                child: Column(
                  children: <Widget>[
                    ListTileTheme(
                      contentPadding: const EdgeInsets.only(left: 10),
                      dense: true,
                      horizontalTitleGap: 0.0,
                      minLeadingWidth: 0,
                      child: ExpansionTile(
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.transparent)),
                        title: Text(
                          widget.note.title.toString(),
                          style: TextStyle(
                            fontFamily: Font_Family_LATO,
                            fontSize: Font_Size_HEADER,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),

                        trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star_border,
                              size: 20,
                              color: Font_Color_UNSELECTED,
                            )),
                        //inkwellFactory: NoSplashFactory(),
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Expanded(
                                child: Text(
                              widget.note.noteDetail!.content,
                              style: TextStyle(
                                  color: Font_Color_Default,
                                  fontSize: Font_Size_CONTENT,
                                  fontFamily: Font_Family_LATO,
                                  fontWeight: FontWeight.w500),
                            )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: Row(children: [
                        Text(
                          DateFormat('d, MMM dd h:mm a').format(widget.note.createdAt),
                          style: TextStyle(
                              color: Font_Color_SUBDOMAIN,
                              fontSize: Font_Size_CONTENT,
                              fontFamily: Font_Family_LATO),
                        ),
                        const Expanded(child: SizedBox()),
                        NotificationWidget(),
                      ]),
                    )
                  ],
                ))));
  }
}