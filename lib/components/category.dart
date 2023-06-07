import 'package:flutter/material.dart';
import 'package:note_master/components/buttonbar.dart';
import 'package:note_master/components/dropdownlist.dart';

import '../models/styling.dart';

List<String> reminderDropDownList = [
  'default',
  'green',
  'weekly',
  'monthly',
  'yearly'
];

class CategoryAlertBoxWidget extends StatefulWidget {
  const CategoryAlertBoxWidget({super.key});

  @override
  State<CategoryAlertBoxWidget> createState() => _CategoryAlertBoxWidgetState();
}

class _CategoryAlertBoxWidgetState extends State<CategoryAlertBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      titlePadding: const EdgeInsets.only(left: 50, top: 20),
      title: Text(
        'Add New Category',
        style: TextStyle(
            color: Font_Color_Default,
            fontFamily: Font_Family_LATO,
            fontSize: Font_Size_HEADER,
            fontWeight: FontWeight.w500),
      ),
      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DropDownFieldWidget(
            dropdownValue: reminderDropDownList,
          ),
          const SizedBox(
            height: 5,
          ),
          const CategoryTextFieldWidget(),
        ],
      ),
      actions: const [ButtonBarFieldWidget()],
    );
  }
}

class CategoryTextFieldWidget extends StatefulWidget {
  const CategoryTextFieldWidget({super.key});

  @override
  State<CategoryTextFieldWidget> createState() =>
      _CategoryTextFieldWidgetState();
}

class _CategoryTextFieldWidgetState extends State<CategoryTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 34,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color.fromRGBO(245, 245, 245, 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10, right: 5),
                child: const Icon(
                  Icons.edit_note,
                  color: Colors.black,
                  size: 20,
                )),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(right: 15, bottom: 15),
                    hintText: 'Write your category name',
                    border: InputBorder.none),
                //focusNode: _focusNode,
                style: TextStyle(
                  fontSize: Font_Size_DIALOG,
                  fontFamily: Font_Family_LATO,
                ),
              ),
            ),
          ],
        ));
  }
}
