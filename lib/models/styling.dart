import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//Theme
Color Theme_Color_ROOT = Colors.black;
Color Theme_Color_DOMAIN = const Color.fromRGBO(233, 241, 245, 1);
Color Theme_Color_SUBDOMAIN = const Color.fromRGBO(245, 245, 245, 1);
Color Theme_Color_SYSTEM = const Color.fromRGBO(37, 87, 218, 1);
ThemeData appThemeLight =
    ThemeData.light().copyWith(primaryColor: Theme_Color_DOMAIN);
ThemeData appThemeDark = ThemeData.dark().copyWith(
    primaryColor: Colors.white,);
//Category
Color Category_BorderColor_DESELECTED = const Color.fromRGBO(228, 236, 240, 1);
Color Category_Color_DESELECTED = const Color.fromRGBO(246, 250, 252, 1);
Color Category_Color_SELECTED = Colors.white;

//Font
Color Font_Color_Default = Colors.black;
Color Font_Color_UNSELECTED = const Color.fromRGBO(190,186,203,1);
Color Font_Color_SUBDOMAIN = const Color.fromRGBO(154, 155, 157, 1);
double Font_Color_CONTENT = 12;
String Font_Family_LATO = 'Lato';
double Font_Size_HEADER = 20;
double Font_Size_DIALOG = 15;
//Content
double Expansion_Height_UNTAP = 50;
double Expansion_Height_TAP = 107;

//DateTime Format
DateFormat formattedDate = DateFormat('dd.MM.yyyy HH:mm:ss');

class BackgroundTheme{
  Color Theme_Color_ROOT;
  Color Theme_Color_DOMAIN;
  Color Theme_Color_SUBDOMAIN;
  BackgroundTheme(this.Theme_Color_ROOT,this.Theme_Color_DOMAIN, this.Theme_Color_SUBDOMAIN){
    SetSystemBarColor(Theme_Color_DOMAIN);
  }

}

class CurrentTheme extends ChangeNotifier {

  BackgroundTheme _theme = BackgroundTheme(Theme_Color_ROOT,Theme_Color_DOMAIN,Theme_Color_SUBDOMAIN);

  BackgroundTheme get theme => _theme;
  
  void setThemeStyle(int index) {
    switch(index){
      case 0:
        Theme_Color_ROOT = Colors.black;
        Theme_Color_DOMAIN = const Color.fromRGBO(233, 241, 245, 1);
        Theme_Color_SUBDOMAIN = const Color.fromRGBO(245, 245, 245, 1);     
        break;
      case 1:
          Theme_Color_ROOT = const Color.fromRGBO(76, 205, 178, 1);
          Theme_Color_DOMAIN = const Color.fromRGBO(208, 235, 213, 1);
          Theme_Color_SUBDOMAIN = const Color.fromRGBO(155, 210, 172, 1);   
        break;
      case 2:
          Theme_Color_ROOT = const Color.fromRGBO(199, 106, 225, 1);
          Theme_Color_DOMAIN = const Color.fromRGBO(228, 202, 245, 1);
          Theme_Color_SUBDOMAIN = const Color.fromRGBO(207, 172, 234, 1);  
        break;
      case 3:
          Theme_Color_ROOT = const Color.fromRGBO(48, 163, 209, 1);
          Theme_Color_DOMAIN = const Color.fromRGBO(191, 225, 243, 1);
          Theme_Color_SUBDOMAIN = const Color.fromRGBO(139, 202, 227, 1);    
        break;
      case 4:
          Theme_Color_ROOT = const Color.fromRGBO(224, 93, 114, 1);
          Theme_Color_DOMAIN = const Color.fromRGBO(245, 228, 226, 1);
          Theme_Color_SUBDOMAIN = const Color.fromRGBO(242, 184, 193, 1); 
        break;
    }  
    _theme = BackgroundTheme(Theme_Color_ROOT,Theme_Color_DOMAIN,Theme_Color_SUBDOMAIN);

    //change the color of system navigation bar and status bar
    SetSystemBarColor(_theme.Theme_Color_DOMAIN);
    notifyListeners();
  }
}

void SetSystemBarColor(Color navigationBarColor){
    SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: navigationBarColor, // Set the background color of the system navigation bar
      statusBarColor: Colors.transparent, // Set the status bar color to transparent
      statusBarIconBrightness: Brightness.dark
    ));
}