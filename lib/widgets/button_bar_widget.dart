import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/layout.dart';
import 'package:provider/provider.dart';

import '../models/notereminder.dart';
import '../models/styling.dart';
import '../pages/home_page.dart';
import '../services/data_access.dart';

class ButtonBarWidget extends StatefulWidget {
  NoteReminder? noteReminder;
  NoteCategory? noteCategoryToBeAdded;
  NoteCategory? noteCategoryToBeRemoved;
  LayoutDataProvider? layoutDataProvider;
  ButtonBarWidget(
      {this.noteReminder, this.noteCategoryToBeAdded, this.noteCategoryToBeRemoved, this.layoutDataProvider, key});

  @override
  State<ButtonBarWidget> createState() => _ButtonBarWidgetState();
}

class _ButtonBarWidgetState extends State<ButtonBarWidget> {
  bool isReminderOver(DateTime? reminderTime) {
    return reminderTime!.difference(DateTime.now()) > Duration.zero;
  }

  void toggleReminder(DateTime? reminderAt) {
    if (isReminderOver(reminderAt)) {
      setState(() {
        currentNote!.noteReminder!.notificationText =
            widget.noteReminder!.notificationText;
        currentNote!.noteReminder!.remindedAt = widget.noteReminder!.remindedAt;
        currentNote!.noteReminder!.repetitionId =
            widget.noteReminder!.repetitionId;
      });
    }
  }

  void resetReminder(NoteReminder noteReminder) {}

  @override
  Widget build(BuildContext context) {
    return widget.noteCategoryToBeRemoved != null 
      && (widget.noteCategoryToBeRemoved!.id == category_default_ID
      || widget.noteCategoryToBeRemoved!.id == 0)
      ? ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        layoutBehavior: ButtonBarLayoutBehavior.constrained,
        children: [
          TextButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: Text(
              'OK',
              style: TextStyle(
                fontFamily: Font_Family_LATO,
                fontSize: Font_Size_DIALOG,
                color: Theme_Color_SYSTEM,
              ),
            ),
          ),          
        ],  
      )
      : ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        layoutBehavior: ButtonBarLayoutBehavior.constrained,
        children: <Widget>[
          TextButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: Font_Family_LATO,
                fontSize: Font_Size_DIALOG,
                color: Theme_Color_SYSTEM,
              ),
            ),
          ),
          Container(
            color: PopUpBox_Color,
            child: const SizedBox(height: 20,width: 1,),
          ),
          TextButton(
            onPressed: () {
              if (widget.noteReminder != null) {
                toggleReminder(widget.noteReminder!.remindedAt);
              }
              if (widget.noteCategoryToBeAdded != null) {
                postCategoryAsync(widget.noteCategoryToBeAdded!)
                    .then((value) => widget.noteCategoryToBeAdded!.id = value)
                    .whenComplete(() => setState(() {
                          widget.layoutDataProvider!
                              .addLatestCategoriesToList(widget.noteCategoryToBeAdded!);
                        }));
              }
              if (widget.noteCategoryToBeRemoved != null) {
                deleteCategoryAsync(widget.noteCategoryToBeRemoved!)
                    .whenComplete(() => setState(() {
                          widget.layoutDataProvider!
                              .removeCurrentCategoriesFromList(widget.noteCategoryToBeRemoved!);

                        }));
              }
              Navigator.of(context).pop();
            },
            child: Text(
              widget.noteCategoryToBeRemoved != null ? "OK": 'DONE',
              style: TextStyle(
                fontFamily: Font_Family_LATO,
                fontSize: Font_Size_DIALOG,
                color: Theme_Color_SYSTEM,
              ),
            ),
          ),
        ],
      );
  }
}
