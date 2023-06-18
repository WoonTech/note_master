import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_master/models/repetition.dart';
import 'package:note_master/pages/checklistpage.dart';
import 'package:note_master/pages/homepage.dart';
import 'package:note_master/pages/notepage.dart';
import 'package:note_master/services/category_access.dart';
import 'package:note_master/utils/dataAccess.dart';
import 'package:provider/provider.dart';
import 'constants/status.dart';
import 'models/category.dart';
import 'models/layout.dart';
import 'models/styling.dart';
import 'services/repetition_access.dart';

int _current = 0;
String _selectText = 'reminder: 5 days';

List<String> dropdownList = ['Notes', 'reminder: 10 days', 'reminder: 20 days'];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeData theme = appThemeLight;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initializeData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error occurred while initializing data'),
              ),
            ),
          );
        } else {
          return MaterialApp(
            home: Scaffold(
                resizeToAvoidBottomInset: false,
                body: ChangeNotifierProvider(
                  create: (context) => LayoutDataProvider(),
                  child: const MaterialApp(
                    home: SwipeNavigation(),
                  ),
                )),
          );
        }
      },
    );
  }

  @override
  /*Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LayoutDataProvider(),
      child: const MaterialApp(
        home: SwipeNavigation(),
      ),
    );
  }*/

  void updateThemeFromSharedPref() async {}
  Future initializeData() async {
    await SQLDataAccess().initialiseDBAsync();
    var categories = await getCategoriesAsync();
    if (categories.isEmpty) {
      var currentTime = DateTime.now();
      var nmNoteCategory = NoteCategory(
          createdAt: currentTime,
          updatedAt: currentTime,
          name: category_default,
          status: activeStatus,
          type: note_type,
          colorId: 1);
      var nmChecklistCategory = NoteCategory(
          createdAt: currentTime,
          updatedAt: currentTime,
          name: category_default,
          status: activeStatus,
          type: checklist_type,
          colorId: 1);
      await postCategoryAsync(nmNoteCategory);
      await postCategoryAsync(nmChecklistCategory);
      categories = await getCategoriesAsync();
    }
    categories.add(NoteCategory(
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: "Add New +",
        status: activeStatus,
        type: note_type,
        colorId: 1));

    var repetitions = await getRepetitionsAsync();
    if (repetitions.isEmpty) {
      List<NoteRepetition> repetitionList = [
        NoteRepetition(repetitionText: 'only once'),
        NoteRepetition(repetitionText: 'daily'),
        NoteRepetition(repetitionText: 'weekly'),
        NoteRepetition(repetitionText: 'monthly'),
        NoteRepetition(repetitionText: 'yearly'),
      ];
      await postRepetitionsAsync(repetitionList);
      repetitions = await getRepetitionsAsync();
    }

    noteRepetitions = repetitions;
    noteCategories = categories;
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
          children: [HomePage(), CheckListPage()],
        ),
      ),
    );
  }
}
