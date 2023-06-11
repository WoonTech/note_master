import 'package:flutter/material.dart';
import 'package:note_master/services/category_access.dart';
import 'package:provider/provider.dart';

import '../components/card.dart';
import '../models/category.dart';
import '../models/layout.dart';
import '../models/noteheader.dart';
import '../models/styling.dart';
import '../services/note_access.dart';
import '../utils/data_access.dart';
import 'notepage.dart';

int _current = 0;
String _selectText = 'reminder: 5 days';

List<String> dropdownList = ['Notes', 'reminder: 10 days', 'reminder: 20 days'];

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<NMCategory> categories = [];
  @override
  void initState() {
    super.initState();
    GetCategories();
    //Provider.of<CurrentTheme>(context, listen: false).setThemeStyle(0);
    _current = 0;
  }

  Future<void> GetCategories() async {
    List<NMCategory> data =
        (await getCategoriesAsync()).where((c) => c.type == note_type).toList();
    setState(() {
      categories = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Consumer<LayoutDataProvider>(
            builder: (context, currentTheme, child) => Stack(
                  children: [
                    Container(
                      color: currentTheme.theme.Theme_Color_SUBDOMAIN,
                    ),
                    BodyWidget(
                        currentTheme: currentTheme, categories: categories),
                    const SearchBarWidget()
                  ],
                )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NotePage()));
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
  final LayoutDataProvider currentTheme;
  final List<NMCategory> categories;
  const BodyWidget(
      {required this.currentTheme, required this.categories, super.key});

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
    _current = 0;
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
    return Positioned.fill(
      top: 80,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            color: widget.currentTheme.theme.Theme_Color_SUBDOMAIN,
          ),
          Positioned.fill(
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: widget.currentTheme.theme.Theme_Color_DOMAIN),
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
                            '${notes.length} notes',
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
                            itemCount: widget.categories.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _current = index;
                                    Provider.of<LayoutDataProvider>(context,
                                            listen: false)
                                        .setThemeStyle(index);
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    border: _current == index
                                        ? Border.all(
                                            color: widget.currentTheme.theme
                                                .Theme_Color_ROOT)
                                        : Border.all(
                                            color:
                                                Category_BorderColor_DESELECTED),
                                    color: _current == index
                                        ? Category_Color_SELECTED
                                        : Category_Color_DESELECTED,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 10, top: 6, bottom: 6),
                                    child: Text(widget.categories[index].name,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: _current == index
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
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NotePage(
                                                  currentNote: notes.values
                                                      .elementAt(index))));
                                    },
                                    child: CardWidget(
                                      note: notes.values.elementAt(index),
                                      currentTheme: widget.currentTheme,
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

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

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
                                child: TextField(
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 15),
                                      hintText: 'Search your note',
                                      hintStyle: TextStyle(
                                          color: Font_Color_TYPE,
                                          fontWeight: FontWeight.w500),
                                      border: InputBorder.none),
                                  //focusNode: _focusNode,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Lato',
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
