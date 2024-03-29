import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:note_master/models/layout.dart';

//Color Icon_Color_DESELECT = const Color.fromRGBO();
ThemeData appThemeLight =
    ThemeData.light().copyWith(primaryColor: Theme_Color_DOMAIN);
ThemeData appThemeDark = ThemeData.dark().copyWith(
  primaryColor: Primary_Color,
);
//Them
Color Primary_Color = Colors.white;
//Category
Color Category_BorderColor_DESELECTED = const Color.fromRGBO(228, 236, 240, 1);
Color Category_Color_DESELECTED = const Color.fromRGBO(246, 250, 252, 1);
Color Category_Color_SELECTED = Colors.white;

//Font
Color Font_Color_Default = Colors.black;
Color Font_Color_Content = const Color.fromRGBO(79, 84, 88, 1);
Color Font_Color_UNSELECTED = Color.fromARGB(255, 152, 150, 150);
Color Font_Color_SUBDOMAIN = const Color.fromRGBO(154, 155, 157, 1);
Color Font_Color_DETAILS = const Color.fromRGBO(129, 135, 135, 1);
Color Font_Color_TYPE = Colors.grey.shade400;
double Font_Size_CONTENT = 12;
String Font_Family_LATO = 'Lato';
double Font_Size_TITLE = 32;
double Font_Size_HEADER = 20;
double Font_Size_DIALOG = 15;
double Font_Size_AppBar_Selected = 20;
double Font_Size_AppBar_Unselected = 18;
//Icons
Color Icon_Color_Close = const Color.fromARGB(255, 152, 150, 150);
Color Icon_Color_Pinned = const Color.fromRGBO(252, 196, 25, 1);
Color Icon_Inactive_Color = Color.fromARGB(255, 152, 150, 150);
Color Icon_Visbility_Color = Color.fromARGB(255, 152, 150, 150);
Color Icon_Active_Color = Colors.black;

//Content
double Expansion_Height_UNTAP = 50;
double Expansion_Height_TAP = 107;
Color Notepad_Color = const Color.fromRGBO(245, 245, 245, 1);

//DateTime Format
DateFormat formattedDate = DateFormat('d, MMM dd h:mm a');

//Notification
Color PopUpBox_Color = const Color.fromARGB(255, 229, 229, 229);
