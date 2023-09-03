import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_master/models/styling.dart';
import 'package:note_master/widgets/popup_note_widget.dart';

class NoteCardDetailWidget extends StatefulWidget {
  final Offset childOffset;
  final Size childSize;
  final Widget child;
  final Widget notePage;
  const NoteCardDetailWidget(
      {super.key,
      required this.childOffset,
      required this.childSize,
      required this.child,
      required this.notePage});

  @override
  State<NoteCardDetailWidget> createState() => _NoteCardDetailWidgetState();
}

class _NoteCardDetailWidgetState extends State<NoteCardDetailWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final maxMenuWidth = size.width * 0.42;
    final maxMenuHeight = size.height * 0.1;
    final rightOffset = widget.childOffset.dx +
        3; // somehow the card widget has a default padding value of 3
    final topOffset =
        (widget.childOffset.dy + maxMenuHeight + widget.childSize.height) <
                size.height
            ? widget.childOffset.dy + widget.childSize.height
            : widget.childOffset.dy - maxMenuHeight;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            Positioned(
                top: topOffset,
                //left: leftOffset,
                right: rightOffset,
                child: TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 200),
                    builder: (BuildContext context, value, Widget? child) {
                      return Transform.scale(
                        scale: value,
                        alignment: Alignment.center,
                        child: child,
                      );
                    },
                    child: Container(
                      width: maxMenuWidth,
                      height: maxMenuHeight,
                      decoration: BoxDecoration(
                          color: Primary_Color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                spreadRadius: 1),
                          ]),
                      child: ClipRRect(
                        child: PopUpMenuNoteWidget(
                            notePageWidget: widget.notePage),
                      ),
                    ))),
            Positioned(
              top: widget.childOffset.dy,
              left: widget.childOffset.dx,
              child: AbsorbPointer(
                absorbing: true,
                child: Container(
                  width: widget.childSize.width,
                  height: widget.childSize.height,
                  child: widget.child,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
