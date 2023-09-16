import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_master/widgets/category_widget.dart';
import 'package:note_master/constants/status.dart';
import 'package:note_master/widgets/notecard_detail_widget.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:vibration/vibration.dart';
import '../models/styling.dart';
import '../widgets/notecard_widget.dart';
import '../models/category.dart';
import '../models/layout.dart';
import '../models/noteheader.dart';
import '../services/data_access.dart';
import 'notepage.dart';

late String selectedPage;
late bool isHideContent;
int currentCategoryID = 1;
late List<NoteHeader> correspondingNotes;
TextEditingController controller = TextEditingController();
ItemScrollController categoryBarController = ItemScrollController();
int selectedIndex = 0;
List<String> dropdownList = ['Notes', 'reminder: 10 days', 'reminder: 20 days'];

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    currentCategoryID = 0;
    selectedPage = notesPage;
    isHideContent = false;
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
              Visibility(
                visible: selectedPage == notesPage,
                child: BodyWidget(
                  layoutData: layoutData,
                ),
              ),
              Positioned(
                  top: 15,
                  left: 10,
                  right: 10,
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 50,
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedPage = notesPage;
                                });
                              },
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Colors
                                        .transparent; // Remove overlay color
                                  },
                                ),
                              ),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text('Notes',
                                      style: TextStyle(
                                        fontSize: selectedPage == notesPage
                                            ? Font_Size_AppBar_Selected
                                            : Font_Size_AppBar_Unselected,
                                        fontFamily: Font_Family_LATO,
                                        fontWeight: selectedPage == notesPage
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: selectedPage == notesPage
                                            ? Font_Color_Default
                                            : Font_Color_UNSELECTED,
                                      )))),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedPage = checklistPage;
                                });
                              },
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return Colors
                                        .transparent; // Remove overlay color
                                  },
                                ),
                              ),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text('Checklists',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: selectedPage == checklistPage
                                            ? Font_Size_AppBar_Selected
                                            : Font_Size_AppBar_Unselected,
                                        fontFamily: Font_Family_LATO,
                                        fontWeight:
                                            selectedPage == checklistPage
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                        color: selectedPage == checklistPage
                                            ? Font_Color_Default
                                            : Font_Color_UNSELECTED,
                                      ))))
                        ],
                      ))),
              Positioned(
                  top: 70,
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
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 6,
                                    left: 10,
                                    bottom: 6,
                                    right: 10), //height 34
                                child: Container(
                                    height: 34,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color:
                                            Color.fromRGBO(245, 245, 245, 1)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Focus(
                                            autofocus: false,
                                            child: TextField(
                                              autofocus: false,
                                              controller: controller,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 15,
                                                        right: 15,
                                                        bottom: 15),
                                                hintText: 'Search your note',
                                                hintStyle: TextStyle(
                                                    color: Font_Color_TYPE,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Lato',
                                              ),
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                        AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return ScaleTransition(
                                                  scale: animation,
                                                  child: child);
                                            },
                                            child: controller.text.isEmpty
                                                ? Container(
                                                    key: Key('search'),
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(
                                                      Icons.search,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ))
                                                : Container(
                                                    key: Key('close'),
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                      size: 20,
                                                    )))
                                      ],
                                    ))))
                      ],
                    ),
                  ))
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
    currentCategoryID = 1;
  }

  Future<void> getNotes() async {
    var cacheNotes = await getNotesAsync();
    setState(() {
      for (var cacheNote in cacheNotes) {
        notes[cacheNote.id!] = cacheNote;
      }
    });
  }

  void _navigateToPreviousPage() {
    if (selectedIndex > 0) {
      selectedIndex--;
    }
    setState(() {
      if (selectedIndex >= 0) {
        currentCategoryID = noteCategories[selectedIndex].id!;
        //categoryBarController.jumpTo(index: selectedIndex);
        categoryBarController.scrollTo(
            index: selectedIndex, duration: const Duration(milliseconds: 200));
        widget.layoutData.setThemeStyle(noteCategories[selectedIndex].colorId);
      }
    });
  }

  void _navigateToNextPage() {
    if (selectedIndex < noteCategories.length - 1) {
      selectedIndex++;
    }

    if (selectedIndex == noteCategories.length - 1) {
      showDialog(
          context: context,
          builder: (context) => CategoryAlertBoxWidget(
                layoutDataProvider: widget.layoutData,
                categoryType: note_type,
              ));
      selectedIndex--;
    } else {
      setState(() {
        if (selectedIndex < noteCategories.length - 1) {
          currentCategoryID = noteCategories[selectedIndex].id!;
          categoryBarController.scrollTo(
              index: selectedIndex,
              duration: const Duration(milliseconds: 200));
          widget.layoutData
              .setThemeStyle(noteCategories[selectedIndex].colorId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    correspondingNotes = controller.text.isEmpty == false
        ? notes.values
            .where((note) => note.noteDetail!.content
                .toLowerCase()
                .contains(controller.text.toLowerCase()))
            .toList()
        : currentCategoryID == category_default_ID
            ? notes.values.toList()
            : notes.values
                .where((element) => element.categoryId == currentCategoryID)
                .toList();
    correspondingNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return Positioned.fill(
      top: 90,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: Colors.transparent,
          ),
          Positioned.fill(
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
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
                      const SizedBox(height: 35),
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isHideContent = !isHideContent;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(
                                isHideContent
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Font_Color_UNSELECTED,
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Row(children: const [
                            SizedBox(
                              width: 5,
                            ),
                          ])),
                          Text(
                            '${correspondingNotes.length} notes',
                            style: TextStyle(
                                fontSize: 16, color: Font_Color_UNSELECTED),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15),
                        height: 28,
                        key: const Key('CategoriesBar'),
                        child: ScrollablePositionedList.builder(
                            //physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemScrollController: categoryBarController,
                            itemCount: noteCategories.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onLongPressStart: (details) {
                                  Vibration.vibrate(
                                      duration: 100, amplitude: 50);
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          RemoveCategoryAlertBoxWidget(
                                            category:
                                                noteCategories[selectedIndex],
                                            layoutDataProvider:
                                                widget.layoutData,
                                          ));
                                },
                                onTap: () {
                                  var originalIndex = selectedIndex;
                                  selectedIndex = index;
                                  if (selectedIndex ==
                                      noteCategories.length - 1) {
                                    selectedIndex = originalIndex;
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
                                      currentCategoryID =
                                          noteCategories[index].id!;
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
                                    border: currentCategoryID ==
                                            noteCategories[index].id
                                        ? Border.all(
                                            color: widget.layoutData.theme
                                                .Theme_Color_ROOT)
                                        : Border.all(
                                            color:
                                                Category_BorderColor_DESELECTED),
                                    color: currentCategoryID ==
                                            noteCategories[index].id
                                        ? Category_Color_SELECTED
                                        : Category_Color_DESELECTED,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 10, top: 6, bottom: 6),
                                    child: Text(noteCategories[index].name,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: currentCategoryID ==
                                                    noteCategories[index].id
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
                          child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dx > 0) {
                            _navigateToPreviousPage();
                          } else if (details.velocity.pixelsPerSecond.dx < 0) {
                            _navigateToNextPage();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: correspondingNotes.length,
                              itemBuilder: (context, index) {
                                return NoteCardHolderWidget(
                                  note: correspondingNotes.elementAt(index),
                                  currentTheme: widget.layoutData,
                                  contentHeight: _contentHeight,
                                  isHideContent: isHideContent,
                                  index: index,
                                );
                              }),
                        ),
                      ))
                    ],
                  ))),
        ],
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
