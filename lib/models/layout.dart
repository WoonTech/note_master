import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:note_master/models/noteheader.dart';
import 'package:note_master/models/repetition.dart';
import 'package:note_master/services/category_access.dart';
import 'package:note_master/services/note_access.dart';

import '../components/category.dart';
import 'category.dart';

//Theme
Color Theme_Color_ROOT = Colors.black;
Color Theme_Color_DOMAIN = const Color.fromRGBO(233, 241, 245, 1);
Color Theme_Color_SUBDOMAIN = const Color.fromRGBO(245, 245, 245, 1);
Color Theme_Color_SYSTEM = const Color.fromRGBO(37, 87, 218, 1);

//Parameter
int Category = 0;
HashMap<int, NoteHeader> notes = HashMap();
List<NoteCategory> noteCategories = [];
List<NoteRepetition> noteRepetitions = [];
NoteHeader? currentNote;

class BackgroundTheme {
  Color Theme_Color_ROOT;
  Color Theme_Color_DOMAIN;
  Color Theme_Color_SUBDOMAIN;
  int Category;
  BackgroundTheme(this.Theme_Color_ROOT, this.Theme_Color_DOMAIN,
      this.Theme_Color_SUBDOMAIN, this.Category) {
    SetSystemBarColor(Theme_Color_DOMAIN);
  }
}

class LayoutDataProvider extends ChangeNotifier {
  BackgroundTheme _theme = BackgroundTheme(
      Theme_Color_ROOT, Theme_Color_DOMAIN, Theme_Color_SUBDOMAIN, Category);

  BackgroundTheme get theme => _theme;

  void initialize() {
    setThemeStyle(0);
  }

  void setThemeStyle(int index) {
    switch (index) {
      case 1:
        Theme_Color_ROOT = Colors.black;
        Theme_Color_DOMAIN = const Color.fromRGBO(233, 241, 245, 1);
        Theme_Color_SUBDOMAIN = const Color.fromRGBO(245, 245, 245, 1);
        Category = 0;
        break;
      case 2:
        Theme_Color_ROOT = const Color.fromRGBO(76, 205, 178, 1);
        Theme_Color_DOMAIN = const Color.fromRGBO(208, 235, 213, 1);
        Theme_Color_SUBDOMAIN = const Color.fromRGBO(155, 210, 172, 1);
        Category = 1;
        break;
      case 3:
        Theme_Color_ROOT = const Color.fromRGBO(199, 106, 225, 1);
        Theme_Color_DOMAIN = const Color.fromRGBO(228, 202, 245, 1);
        Theme_Color_SUBDOMAIN = const Color.fromRGBO(207, 172, 234, 1);
        Category = 2;
        break;
      case 4:
        Theme_Color_ROOT = const Color.fromRGBO(48, 163, 209, 1);
        Theme_Color_DOMAIN = const Color.fromRGBO(191, 225, 243, 1);
        Theme_Color_SUBDOMAIN = const Color.fromRGBO(139, 202, 227, 1);
        Category = 3;
        break;
      case 5:
        Theme_Color_ROOT = const Color.fromRGBO(224, 93, 114, 1);
        Theme_Color_DOMAIN = const Color.fromRGBO(245, 228, 226, 1);
        Theme_Color_SUBDOMAIN = const Color.fromRGBO(242, 184, 193, 1);
        Category = 4;
        break;
    }
    _theme = BackgroundTheme(
        Theme_Color_ROOT, Theme_Color_DOMAIN, Theme_Color_SUBDOMAIN, Category);

    //change the color of system navigation bar and status bar
    SetSystemBarColor(_theme.Theme_Color_DOMAIN);
    notifyListeners();
  }

  void addLatestNoteToList(NoteHeader noteHeader) {
    notes[noteHeader.id!] = noteHeader;
    notifyListeners();
  }

  void addLatestCategoriesToList(NoteCategory noteCategory) {
    noteCategories.insert(noteCategories.length - 1, noteCategory);
    notifyListeners();
  }

  Future<void> getNoteCategories() async {
    noteCategories =
        (await getCategoriesAsync()).where((c) => c.type == note_type).toList();
    notifyListeners();
  }

  /*Future<void> getCheckListCategories() async {
    categories = (await getCategoriesAsync())
        .where((c) => c.type == checklist_type)
        .toList();
    notifyListeners();
  }*/

  Future<void> getNote() async {
    var cacheNotes = await getNotesAsync();
    for (var cacheNote in cacheNotes) {
      notes[cacheNote.id!] = cacheNote;
    }
    notifyListeners();
  }

  void showCategoryDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => CategoryAlertBoxWidget(
              categoryType: note_type,
            ));
  }
}

void SetSystemBarColor(Color navigationBarColor) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          navigationBarColor, // Set the background color of the system navigation bar
      statusBarColor:
          Colors.transparent, // Set the status bar color to transparent
      statusBarIconBrightness: Brightness.dark));
}
