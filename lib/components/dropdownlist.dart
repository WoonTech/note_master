import 'package:flutter/material.dart';

import '../models/styling.dart';

class DropDownFieldWidget extends StatelessWidget {
  final List<String> dropdownValue;
  const DropDownFieldWidget({required this.dropdownValue, super.key});

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
                dropdownValue: dropdownValue,
              ),
            ),
          ],
        ));
  }
}

class DropDownListWidget extends StatefulWidget {
  final List<String> dropdownValue;
  const DropDownListWidget({required this.dropdownValue, super.key});

  @override
  State<DropDownListWidget> createState() => _DropDownListWidgetState();
}

class _DropDownListWidgetState extends State<DropDownListWidget> {
  @override
  Widget build(BuildContext context) {
    String selectedValue = widget.dropdownValue.first;
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: DropdownButton<String>(
          value: selectedValue,
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Color.fromRGBO(246, 250, 252, 1),
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
          underline: Container(),
          items: widget.dropdownValue.map((value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
        ));
  }
}
