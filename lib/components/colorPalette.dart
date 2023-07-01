import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:note_master/components/category.dart';
import 'package:note_master/components/circularRadioButton.dart';

import '../models/layout.dart';

class ColorPaletteWidget extends StatefulWidget {
  const ColorPaletteWidget({super.key});

  @override
  State<ColorPaletteWidget> createState() => _ColorPaletteWidgetState();
}

class _ColorPaletteWidgetState extends State<ColorPaletteWidget> {
  int selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircularRadioButton(
          value: 0,
          selectedValue: selectedValue,
          onChanged: (value) {
            setState(() {
              tmpNoteCategory.colorId = value;
              selectedValue = value;
            });
          },
          color: themeColors[0],
        ),
        SizedBox(
          width: 15,
        ),
        CircularRadioButton(
          value: 1,
          selectedValue: selectedValue,
          onChanged: (value) {
            setState(() {
              tmpNoteCategory.colorId = value;
              selectedValue = value;
            });
          },
          color: themeColors[1],
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
          color: themeColors[2],
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
          color: themeColors[3],
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
          color: themeColors[4],
        ),
      ],
    );
  }
}
