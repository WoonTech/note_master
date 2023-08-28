import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NoteCardDetailWidget extends StatefulWidget {
  final Offset childOffset;
  final Size childSize;
  final Widget child, menuContent;

  const NoteCardDetailWidget(
      {super.key,
      required this.childOffset,
      required this.childSize,
      required this.child,
      required this.menuContent});

  @override
  State<NoteCardDetailWidget> createState() => _NoteCardDetailWidgetState();
}

class _NoteCardDetailWidgetState extends State<NoteCardDetailWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final maxMenuWidth = size.width * 0.70;
    final menuHeight = size.height * 0.35;
    final leftOffset = (widget.childOffset.dx + maxMenuWidth) < size.width
        ? widget.childOffset.dx
        : (widget.childOffset.dx - maxMenuWidth + widget.childSize.width);
    final topOffset =
        (widget.childOffset.dy + menuHeight + widget.childSize.height) <
                size.height
            ? widget.childOffset.dy + widget.childSize.height
            : widget.childOffset.dy - menuHeight;
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
                      height: menuHeight,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black38,
                                blurRadius: 10,
                                spreadRadius: 1),
                          ]),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        child: widget.menuContent,
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
