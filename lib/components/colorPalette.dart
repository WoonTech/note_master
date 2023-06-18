import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_master/components/category.dart';
import 'package:note_master/components/circularRadioButton.dart';

class ColorPaletteWidget extends StatefulWidget {
  const ColorPaletteWidget({super.key});

  @override
  State<ColorPaletteWidget> createState() => _ColorPaletteWidgetState();
}

class _ColorPaletteWidgetState extends State<ColorPaletteWidget> {
  int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularRadioButton(
          value: 1,
          selectedValue: selectedValue,
          onChanged: (value) {
            setState(() {
              tmpNoteCategory.colorId = value;
              selectedValue = value;
            });
          },
          color: Colors.black,
        ),
        SizedBox(
          width: 15,
        ),
        CircularRadioButton(
          value: 2,
          selectedValue: selectedValue,
          onChanged: (value) {
            setState(() {
              tmpNoteCategory.colorId = value;
              selectedValue = value;
            });
          },
          color: Color.fromRGBO(155, 210, 172, 1),
        ),
        SizedBox(
          width: 15,
        ),
        CircularRadioButton(
          value: 3,
          selectedValue: selectedValue,
          onChanged: (value) {
            setState(() {
              tmpNoteCategory.colorId = value;
              selectedValue = value;
            });
          },
          color: Color.fromRGBO(139, 202, 227, 1),
        ),
        SizedBox(
          width: 15,
        ),
        CircularRadioButton(
          value: 4,
          selectedValue: selectedValue,
          onChanged: (value) {
            setState(() {
              tmpNoteCategory.colorId = value;
              selectedValue = value;
            });
          },
          color: Color.fromRGBO(207, 172, 234, 1),
        ),
        SizedBox(
          width: 15,
        ),
        CircularRadioButton(
          value: 5,
          selectedValue: selectedValue,
          onChanged: (value) {
            setState(() {
              tmpNoteCategory.colorId = value;
              selectedValue = value;
            });
          },
          color: Color.fromRGBO(242, 184, 193, 1),
        ),
      ],
    );
  }
}
