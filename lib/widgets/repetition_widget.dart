import 'package:flutter/material.dart';
import 'package:note_master/widgets/reminder.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/layout.dart';
import 'package:note_master/models/repetition.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';
import '../models/styling.dart';

class DropDownFieldWidget extends StatelessWidget {
  List<NoteRepetition>? noteRepetitions;
  List<NoteCategory>? noteCategories;
  DropDownFieldWidget({this.noteRepetitions, this.noteCategories, key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 34,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: const Icon(
                  Icons.repeat,
                  color: Colors.black,
                  size: 20,
                )),
            Expanded(
              child: noteRepetitions != null
                  ? RepetitionDropDownListWidget(
                      repetitions: noteRepetitions!,
                    )
                  : CategoryDropDownListWidget(categories: noteCategories!),
            ),
          ],
        ));
  }
}

class RepetitionDropDownListWidget extends StatefulWidget {
  final List<NoteRepetition> repetitions;
  const RepetitionDropDownListWidget({required this.repetitions, super.key});

  @override
  State<RepetitionDropDownListWidget> createState() =>
      _RepetitionDropDownListWidgetState();
}

class _RepetitionDropDownListWidgetState
    extends State<RepetitionDropDownListWidget> {
  String selectedValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue = widget.repetitions
        .where(
            (element) => element.id == currentNote!.noteReminder!.repetitionId)
        .first
        .repetitionText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: DropdownButton<String>(
          value: selectedValue,
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Color.fromRGBO(246, 250, 252, 1),
          onChanged: (newIndex) {
            setState(() {
              selectedValue = newIndex!;
              tmpNoteReminder.repetitionId = widget.repetitions
                  .firstWhere(
                      (repetition) => repetition.repetitionText == newIndex)
                  .id!;
            });
          },
          underline: Container(),
          items: widget.repetitions.map((repetition) {
            return DropdownMenuItem(
                value: repetition.repetitionText,
                child: Text(repetition.repetitionText));
          }).toList(),
        ));
  }
}

class CategoryDropDownListWidget extends StatefulWidget {
  final List<NoteCategory> categories;
  const CategoryDropDownListWidget({required this.categories, super.key});

  @override
  State<CategoryDropDownListWidget> createState() =>
      _CategoryDropDownListWidgetState();
}

class _CategoryDropDownListWidgetState
    extends State<CategoryDropDownListWidget> {
  String selectedValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue = widget.categories
            .where((element) => element.id == currentNote!.categoryId)
            .firstOrNull
            ?.name ??
        widget.categories.first.name;
  }

  String _selectedOption = 'Option 1';
  @override
  Widget build(BuildContext context) {
    return Container();
    /*return PopupMenuButton<String>(
      icon: Icon(Icons.arrow_drop_down),
      onSelected: (String newValue) {
        setState(() {
          _selectedOption = newValue;
        });
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'Option 1',
            child: Text('Option 1'),
          ),
          PopupMenuItem(
            value: 'Option 2',
            child: Text('Option 2'),
          ),
          PopupMenuItem(
            value: 'Option 3',
            child: Text('Option 3'),
          ),
        ];
      },
    );*/
  }
}
