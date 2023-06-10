import 'package:flutter/material.dart';
import 'package:note_master/components/reminder.dart';
import 'package:note_master/models/noteheader.dart';
import 'package:intl/intl.dart';
import '../models/layout.dart';
import '../models/styling.dart';

class CardWidget extends StatefulWidget {
  final LayoutDataProvider currentTheme;
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
                child: Padding(
                  padding: 
                    const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              widget.note.title.toString(),
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: Font_Family_LATO,
                                fontSize: Font_Size_HEADER,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            /*const Expanded(child: SizedBox()),*/
                            Icon(
                              Icons.star,
                              color: widget.note.isPinned
                              ?const Color.fromRGBO(252, 196, 25, 1)
                              : Colors.transparent
                            ),
                          ],
                        ),
                        /*const SizedBox(height: 15,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.note.noteDetail!.content,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Font_Color_Content,
                                  fontSize: Font_Size_CONTENT,
                                  fontFamily: Font_Family_LATO,
                                  fontWeight: FontWeight.w500),
                                    ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                            DateFormat('d, MMM dd h:mm a').format(widget.note.createdAt),
                            style: TextStyle(
                                color: Font_Color_SUBDOMAIN,
                                fontSize: Font_Size_CONTENT,
                                fontFamily: Font_Family_LATO),
                            ),
                            const Expanded(child: SizedBox()),
                            NotificationWidget()
                          ],
                        ),
                      */],
                      ),
                    ],      
                  ), 
              )
            )
          )
        );
  }
}