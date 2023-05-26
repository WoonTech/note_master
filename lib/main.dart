import 'package:flutter/material.dart';
import 'package:note_master/pages/homepage.dart';
import 'package:note_master/models/category.dart';

import 'models/styling.dart';

int _current = 0;
String _selectText = 'reminder: 5 days';
List<NMCategory> categories = [
    NMCategory(createdAt: DateTime.now(), updatedAt: DateTime.now(), name: 'Add sdaNew'),
    NMCategory(createdAt: DateTime.now(), updatedAt: DateTime.now(), name: 'Add New'),
    NMCategory(createdAt: DateTime.now(), updatedAt: DateTime.now(), name: 'asdasdasdasdasdsda'),
    NMCategory(createdAt: DateTime.now(), updatedAt: DateTime.now(), name: 'Add New'),
  ];

List<String> dropdownList = [
  'Notes',
  'reminder: 10 days',
  'reminder: 20 days'
];

void main() {
  /*runApp(MaterialApp(
    home: HomePage()
  ));*/   
  runApp(const MyHomePage());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = appThemeLight;
  @override
  void initState() {
    super.initState();
    updateThemeFromSharedPref();
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }

  void updateThemeFromSharedPref() async {

  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState(){
    super.initState();
    //categories = getCategoriesAsync() as List<NMCategory>;
    //Provider.of<CurrentTheme>(context, listen: false).setThemeStyle(0);
    _current = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,      
      body: 
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Consumer<CurrentTheme>(
            builder: (context, currentTheme, child) => Stack(
              children: [
                Container(
                    color: currentTheme.theme.Theme_Color_SUBDOMAIN,
                ),
                BodyWidget(currentTheme: currentTheme),               
                const SearchBarWidget()             
                ],
            )
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*Navigator.push(
            context, 
            MaterialPageRoute(builder: (context)=> NoteWidget())
          );*/
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
