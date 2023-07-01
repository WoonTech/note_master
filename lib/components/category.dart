import 'package:flutter/material.dart';
import 'package:note_master/components/buttonbar.dart';
import 'package:note_master/components/colorPalette.dart';
import 'package:note_master/constants/status.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/models/layout.dart';
import 'package:provider/provider.dart';

import '../models/styling.dart';

late NoteCategory tmpNoteCategory;

class CategoryAlertBoxWidget extends StatefulWidget {
  String categoryType;
  LayoutDataProvider? layoutDataProvider;
  CategoryAlertBoxWidget(
      {required this.categoryType, this.layoutDataProvider, super.key});

  @override
  State<CategoryAlertBoxWidget> createState() => _CategoryAlertBoxWidgetState();
}

class _CategoryAlertBoxWidgetState extends State<CategoryAlertBoxWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitializeCategory();
  }

  Future<void> InitializeCategory() async {
    tmpNoteCategory = NoteCategory(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: "",
        status: activeStatus,
        type: widget.categoryType,
        colorId: category_default_ColorID);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              tmpNoteCategory.name = controller.text;
            },
            controller: controller,
            autofocus: true,
            decoration: InputDecoration.collapsed(
              hintText: 'New category name',
              hintStyle: TextStyle(
                  color: Font_Color_DETAILS,
                  fontFamily: Font_Family_LATO,
                  fontSize: Font_Size_HEADER,
                  fontWeight: FontWeight.w500),
              border: InputBorder.none,
            ),
            style: TextStyle(
                fontFamily: Font_Family_LATO,
                fontSize: Font_Size_HEADER,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 15,
          ),
          ColorPaletteWidget(),
          /*const SizedBox(
            height: 10,
          ),
          const CategoryTextFieldWidget(),*/
        ],
      ),
      actions: [
        ButtonBarWidget(
          layoutDataProvider: widget.layoutDataProvider,
          noteCategoryToBeAdded: tmpNoteCategory,
        )
      ],
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

class RemoveCategoryAlertBoxWidget extends StatefulWidget {
  NoteCategory category;
  LayoutDataProvider layoutDataProvider;
  RemoveCategoryAlertBoxWidget({required this.category, required this.layoutDataProvider, super.key});

  @override
  State<RemoveCategoryAlertBoxWidget> createState() => _RemoveCategoryAlertBoxWidgetState();
}

class _RemoveCategoryAlertBoxWidgetState extends State<RemoveCategoryAlertBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              (widget.category.id == category_default_ID  || widget.category.id == 0)
              ? 'Unable to delete default category'
              : 'Delete ${widget.category.name}?',
              style: TextStyle(
                color: Font_Color_Default,
                fontFamily: Font_Family_LATO,
                fontSize: Font_Size_HEADER,
                fontWeight: FontWeight.w500
              ),
            ),
          )
        ],
      ),
      actions: [
        ButtonBarWidget(
          layoutDataProvider: widget.layoutDataProvider,
          noteCategoryToBeRemoved: widget.category,
        )
      ],
    );
  
  }
}