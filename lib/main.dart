import 'package:flutter/material.dart';
import 'package:note_master/pages/checklist_page.dart';
import 'package:note_master/pages/homepage.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/pages/note_page.dart';
import 'package:note_master/pages/notepad.dart';
import 'package:note_master/utils/data_access.dart';
import 'package:provider/provider.dart';

import 'models/styling.dart';

int _current = 0;
String _selectText = 'reminder: 5 days';
List<NMCategory> categories = [
  NMCategory(
      createdAt: DateTime.now(), updatedAt: DateTime.now(), name: 'Add sdaNew'),
  NMCategory(
      createdAt: DateTime.now(), updatedAt: DateTime.now(), name: 'Add New'),
  NMCategory(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: 'asdasdasdasdasdsda'),
  NMCategory(
      createdAt: DateTime.now(), updatedAt: DateTime.now(), name: 'Add New'),
];

List<String> dropdownList = ['Notes', 'reminder: 10 days', 'reminder: 20 days'];

void main() {
  /*runApp(MaterialApp(
    home: HomePage()
  ));*/
  runApp(MyApp());
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
    dbExists().then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentTheme(),
      child: MaterialApp(
        home: SwipeNavigation(),
      ),
    );
  }

  void updateThemeFromSharedPref() async {}
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //categories = getCategoriesAsync() as List<NMCategory>;
    //Provider.of<CurrentTheme>(context, listen: false).setThemeStyle(0);
    _current = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
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

class SwipeNavigation extends StatefulWidget {
  @override
  _SwipeNavigationState createState() => _SwipeNavigationState();
}

class _SwipeNavigationState extends State<SwipeNavigation> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    if (_currentPageIndex < 1) {
      setState(() {
        _currentPageIndex++;
      });
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToPreviousPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
      });
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _navigateToPreviousPage();
          } else if (details.velocity.pixelsPerSecond.dx < 0) {
            _navigateToNextPage();
          }
        },
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: HomePage(),
            ),
            Container(
              child: CheckListPage(),
            ),
          ],
        ),
      ),
    );
  }
}
