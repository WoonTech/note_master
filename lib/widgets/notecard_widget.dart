import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:note_master/utils/date_utils.dart';
import 'package:note_master/widgets/reminder.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/noteheader.dart';
import 'package:intl/intl.dart';
import '../models/layout.dart';
import '../models/styling.dart';
import '../pages/notepage/notepage.dart';
import 'substring_highlighted_widget.dart';
import 'notecard_detail_widget.dart';

class NoteCardHolderWidget extends StatefulWidget {
  final LayoutDataProvider currentTheme;
  final double contentHeight;
  final NoteHeader note;
  final int index;
  final TextEditingController textEditingController;
  bool isHideContent;
  NoteCardHolderWidget(
      {required this.note,
      required this.currentTheme,
      required this.contentHeight,
      required this.isHideContent,
      required this.index,
      required this.textEditingController,
      super.key});

  @override
  State<NoteCardHolderWidget> createState() => _NoteCardHolderWidgetState();
}

class _NoteCardHolderWidgetState extends State<NoteCardHolderWidget> {
  GlobalKey containerKey = GlobalKey();
  Offset childOffset = Offset(0, 0);
  late Size childSize;
  late Widget cardWidget;
  late Widget notePageWidget;
  @override
  void initState() {
    super.initState();
  }

  getOffset() {
    RenderBox renderBox =
        containerKey.currentContext?.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    setState(() {
      this.childOffset = Offset(offset.dx, offset.dy);
      childSize = size;
    });
  }

  Widget getCard() {
    return CardWidget(
      note: widget.note,
      currentTheme: widget.currentTheme,
      contentHeight: widget.contentHeight,
      isHideContent: widget.isHideContent,
      index: widget.index,
      textEditingController: widget.textEditingController,
    );
  }

  @override
  Widget build(BuildContext context) {
    cardWidget = getCard();
    notePageWidget =
        NotePage(layoutData: widget.currentTheme, cardNote: widget.note);
    return GestureDetector(
        key: containerKey,
        onLongPress: () async {
          getOffset();
          await Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 100),
                  pageBuilder: (context, animation, secondaryAnimiation) {
                    animation = Tween(begin: 0.0, end: 1.0).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: NoteCardDetailWidget(
                        childOffset: childOffset,
                        childSize: childSize,
                        child: cardWidget,
                        notePage: notePageWidget,
                        note: widget.note,
                        layoutDataProvider: widget.currentTheme,
                      ),
                    );
                  },
                  fullscreenDialog: true,
                  opaque: false));
        },
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => notePageWidget));
        },
        child: cardWidget);
  }
}

class CardWidget extends StatefulWidget {
  final LayoutDataProvider currentTheme;
  final double contentHeight;
  final NoteHeader note;
  final int index;
  final TextEditingController textEditingController;
  bool isHideContent;
  CardWidget(
      {required this.note,
      required this.currentTheme,
      required this.contentHeight,
      required this.isHideContent,
      required this.index,
      required this.textEditingController,
      super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool startAnimation = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      transform:
          Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
      curve: Curves.easeInOut,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    color: Primary_Color,
                    border: Border(
                        left: BorderSide(
                            color: rootColors[noteCategories
                                .where((element) =>
                                    element.id ==
                                    (widget.note.categoryId ??
                                        category_default_ID))
                                .first
                                .colorId],
                            width: 7))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            //Here
                            widget.note.title.toString(),
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: Font_Family_LATO,
                              fontSize: Font_Size_HEADER,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Icon(
                            Icons.star,
                            color: widget.note.isPinned
                                ? Icon_Color_Pinned
                                : Colors.transparent,
                          )
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.isHideContent
                              ? Container()
                              : ContentWidget(
                                  content: widget.note.noteDetail!.content,
                                  textEditingController:
                                      widget.textEditingController,
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate.format(widget.note.createdAt),
                            style: TextStyle(
                                color: Font_Color_SUBDOMAIN,
                                fontSize: Font_Size_CONTENT,
                                fontFamily: Font_Family_LATO),
                          ),
                          const Expanded(child: SizedBox()),
                          NotificationWidget(
                              noteReminder: widget.note.noteReminder!)
                        ],
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}

class ContentWidget extends StatelessWidget {
  final String content;
  final TextEditingController textEditingController;
  const ContentWidget(
      {super.key, required this.content, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SubstringHighlight(
            text: content
                .cleanString(), // search result string from database or something
            term: textEditingController.text, // user typed "et"
            maxLines: 3,
            textStyle: TextStyle(
                color: Font_Color_Content,
                fontSize: Font_Size_CONTENT,
                fontFamily: Font_Family_LATO,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
