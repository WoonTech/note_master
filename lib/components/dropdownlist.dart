import 'package:flutter/material.dart';
import 'package:note_master/components/reminder.dart';
import 'package:note_master/models/layout.dart';
import 'package:note_master/models/repetition.dart';
import 'package:path/path.dart';

import '../models/styling.dart';

class DropDownFieldWidget extends StatelessWidget {
  final List<NoteRepetition> repetitions;
  const DropDownFieldWidget({required this.repetitions, super.key});

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
              child: DropDownListWidget(
                repetitions: repetitions,
              ),
            ),
          ],
        ));
  }
}

class DropDownListWidget extends StatefulWidget {
  final List<NoteRepetition> repetitions;
  const DropDownListWidget({required this.repetitions, super.key});

  @override
  State<DropDownListWidget> createState() => _DropDownListWidgetState();
}

class _DropDownListWidgetState extends State<DropDownListWidget> {

  String selectedValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedValue = widget.repetitions.where((element) => element.id == currentNote!.noteReminder!.repetitionId).first.repetitionText;
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
              tmpNoteReminder.repetitionId = widget.repetitions.firstWhere((repetition) => repetition.repetitionText == newIndex).id!;
            });
          },
          underline: Container(),
          items: widget.repetitions.map((repetition) {
            return DropdownMenuItem(value: repetition.repetitionText, child: Text(repetition.repetitionText));
          }).toList(),
        ));
  }
}
