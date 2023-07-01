import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_master/components/category.dart';
import 'package:note_master/constants/status.dart';
import 'package:note_master/services/category_access.dart';
import 'package:provider/provider.dart';

import '../components/card.dart';
import '../models/category.dart';
import '../models/layout.dart';
import '../models/noteheader.dart';
import '../models/styling.dart';
import '../services/note_access.dart';
import '../utils/dataAccess.dart';
import 'notepage.dart';

String _selectText = 'reminder: 5 days';
int currentCategoryIndex = 1;

List<String> dropdownList = ['Notes', 'reminder: 10 days', 'reminder: 20 days'];

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    currentCategoryIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var layoutData = Provider.of<LayoutDataProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              Container(
                color: layoutData.theme.Theme_Color_SUBDOMAIN,
              ),
              BodyWidget(
                layoutData: layoutData,
              ),
              const SearchBarWidget()
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotePage(
                        layoutData: layoutData,
                      )));
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

class BodyWidget extends StatefulWidget {
  final LayoutDataProvider layoutData;
  BodyWidget({required this.layoutData, super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  double _contentHeight = Expansion_Height_UNTAP;
  //List<NoteHeader> note = [];

  @override
  void initState() {
    super.initState();
    getNotes();
    currentCategoryIndex = 1;
  }

  Future<void> getNotes() async {
    var cacheNotes = await getNotesAsync();
    setState(() {
      for (var cacheNote in cacheNotes) {
        notes[cacheNote.id!] = cacheNote;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var correspondingNotes = currentCategoryIndex == category_default_ID
        ? notes.values
        : notes.values
            .where((element) => element.categoryId == currentCategoryIndex);
  print(currentCategoryIndex);
    return Positioned.fill(
      top: 80,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            color: widget.layoutData.theme.Theme_Color_SUBDOMAIN,
          ),
          Positioned.fill(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: widget.layoutData.theme.Theme_Color_DOMAIN),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Row(children: const [
                            Text(
                              'Notes',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.select_all,
                              size: 30,
                            )
                          ])),
                          Text(
                            '${correspondingNotes.length} notes',
                            style: TextStyle(
                                fontSize: 16, color: Font_Color_Default),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        height: 28,
                        key: const Key('CategoriesBar'),
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: noteCategories.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            RemoveCategoryAlertBoxWidget(
                                              category: noteCategories[index],
                                              layoutDataProvider:
                                                  widget.layoutData,
                                            ));
                                },
                                onTap: () {
                                  if (index == noteCategories.length - 1) {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CategoryAlertBoxWidget(
                                              layoutDataProvider:
                                                  widget.layoutData,
                                              categoryType: note_type,
                                            ));
                                  } else {
                                    setState(() {
                                      currentCategoryIndex = noteCategories[index].id!;
                                      widget.layoutData.setThemeStyle(
                                          noteCategories[index].colorId);
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    border: currentCategoryIndex == noteCategories[index].id
                                        ? Border.all(
                                            color: widget.layoutData.theme
                                                .Theme_Color_ROOT)
                                        : Border.all(
                                            color:
                                                Category_BorderColor_DESELECTED),
                                    color: currentCategoryIndex == noteCategories[index].id
                                        ? Category_Color_SELECTED
                                        : Category_Color_DESELECTED,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 10, top: 6, bottom: 6),
                                    child: Text(noteCategories[index].name,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: currentCategoryIndex == noteCategories[index].id
                                                ? Font_Color_Default
                                                : Font_Color_UNSELECTED,
                                            fontSize: Font_Size_CONTENT,
                                            fontFamily: Font_Family_LATO,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: correspondingNotes.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NotePage(
                                                  layoutData: widget.layoutData,
                                                  cardNote: correspondingNotes
                                                      .elementAt(index))));
                                    },
                                    child: CardWidget(
                                      note: correspondingNotes.elementAt(index),
                                      currentTheme: widget.layoutData,
                                      contentHeight: _contentHeight,
                                    ));
                              }),
                        ),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 60,
        right: 15,
        left: 15,
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 13, bottom: 13, right: 10),
                child: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 6, bottom: 6, right: 10), //height 34
                      child: Container(
                          height: 34,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color.fromRGBO(245, 245, 245, 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Focus(
                                  autofocus: false,
                                  child: TextField(
                                    autofocus: false,
                                    controller: controller,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      hintText: 'Search your note',
                                      hintStyle: TextStyle(
                                          color: Font_Color_TYPE,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 20,
                                  ))
                            ],
                          ))))
            ],
          ),
        ));
  }
}

class aReminderWidget extends StatefulWidget {
  const aReminderWidget({super.key});

  @override
  State<aReminderWidget> createState() => _aReminderWidgetState();
}

class _aReminderWidgetState extends State<aReminderWidget> {
  final List<String> textList = [
    "reminder: 5 days",
    "this_is_a111111_long_text"
  ];
  late String _currentItemSelected;
  @override
  void initState() {
    super.initState();
    _currentItemSelected = textList[0];
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return textList.map((str) {
          return PopupMenuItem(
              value: str,
              height: 10,
              child: Text(
                str,
                style: TextStyle(
                    fontSize: Font_Size_CONTENT,
                    fontFamily: Font_Family_LATO,
                    fontWeight: FontWeight.w300,
                    color: Font_Color_SUBDOMAIN),
              ));
        }).toList();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _currentItemSelected,
            style: TextStyle(
              color: Font_Color_SUBDOMAIN,
              fontSize: Font_Size_CONTENT,
              fontFamily: Font_Family_LATO,
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Font_Color_UNSELECTED,
          ),
        ],
      ),
      onSelected: (v) {
        setState(() {
          _currentItemSelected = v;
        });
      },
    );
  }
}
