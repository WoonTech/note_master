import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:note_master/models/layout.dart';

//Color Icon_Color_DESELECT = const Color.fromRGBO();
ThemeData appThemeLight =
    ThemeData.light().copyWith(primaryColor: Theme_Color_DOMAIN);
ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: Colors.white,
);
//Category
Color Category_BorderColor_DESELECTED = const Color.fromRGBO(228, 236, 240, 1);
Color Category_Color_DESELECTED = const Color.fromRGBO(246, 250, 252, 1);
Color Category_Color_SELECTED = Colors.white;

//Font
Color Font_Color_Default = Colors.black;
Color Font_Color_UNSELECTED = const Color.fromRGBO(190, 186, 203, 1);
Color Font_Color_SUBDOMAIN = const Color.fromRGBO(154, 155, 157, 1);
Color Font_Color_DETAILS = const Color.fromRGBO(129, 135, 135, 1);
Color Font_Color_TYPE = Colors.grey.shade400;
double Font_Size_CONTENT = 12;
String Font_Family_LATO = 'Lato';
double Font_Size_TITLE = 32;
double Font_Size_HEADER = 20;
double Font_Size_DIALOG = 15;
//Content
double Expansion_Height_UNTAP = 50;
double Expansion_Height_TAP = 107;
Color Notepad_Color = const Color.fromRGBO(245, 245, 245, 1);
Color NotepadIcon_Color = Colors.black;
//DateTime Format
DateFormat formattedDate = DateFormat('dd.MM.yyyy HH:mm:ss');

