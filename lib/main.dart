import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_master/pages/checklistpage.dart';
import 'package:note_master/pages/homepage.dart';
import 'package:note_master/models/category.dart';
import 'package:note_master/services/category_access.dart';
import 'package:note_master/utils/data_access.dart';
import 'package:provider/provider.dart';
import 'constants/status.dart';
import 'models/layout.dart';
import 'models/styling.dart';

int _current = 0;
String _selectText = 'reminder: 5 days';

List<String> dropdownList = ['Notes', 'reminder: 10 days', 'reminder: 20 days'];

void main() {
  runApp(const MyApp());
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
    SQLDataAccess().initialiseDBAsync().whenComplete(() async {
      await initialize();
    });
    //ensureDBExisted().then((value) => initialize());
    //updateThemeFromSharedPref();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LayoutDataProvider(),
      child: const MaterialApp(
        home: SwipeNavigation(),
      ),
    );
  }

  void updateThemeFromSharedPref() async {}
  Future initialize() async {
    //if category is empty, create all
    var categories = await getCategoriesAsync();
    if(categories.isEmpty){
      var currentTime = DateTime.now();
      var nmNoteCategory = NMCategory(
        createdAt: currentTime, 
        updatedAt: currentTime,
        name: category_default, 
        status: activeStatus,
        type: note_type);
      var nmChecklistCategory = NMCategory(
        createdAt: currentTime, 
        updatedAt: currentTime,
        name: category_default, 
        status: activeStatus,
        type: checklist_type);
      await postCategoryAsync(nmNoteCategory);
      await postCategoryAsync(nmChecklistCategory);
    }
  }
}

class SwipeNavigation extends StatefulWidget {
  const SwipeNavigation({super.key});

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
        duration: Duration(milliseconds: 100),
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
        duration: Duration(milliseconds: 100),
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
