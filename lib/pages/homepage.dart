import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common_widgets/reminder.dart';
import '../models/category.dart';
import '../models/styling.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrentTheme(),
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
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

class BodyWidget extends StatefulWidget {

  final CurrentTheme currentTheme;
  const BodyWidget({required this.currentTheme, super.key});

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  double _contentHeight = Expansion_Height_UNTAP;
  @override
  Widget build(BuildContext context) {

    return Positioned.fill(
      top: 80,
      child:
        Stack(
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                color: widget.currentTheme.theme.Theme_Color_DOMAIN
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(                     
                    children: [
                      const SizedBox(width: 15,),
                      Expanded(
                        child: Row(
                          children:const [
                            Text(
                              'Notes',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(
                              Icons.select_all,
                              size: 30,
                            )
                          ]
                        )
                      ),
                      Text(
                        '60 notes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme_Color_SUBDOMAIN
                        ),
                      ),
                      const SizedBox(width: 15,),
                  ],
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    height: 28,
                    key: const Key('CategoriesBar'),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              _current = index;
                              Provider.of<CurrentTheme>(context, listen: false).setThemeStyle(index);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius:const BorderRadius.all(Radius.circular(15)),
                              border: _current == index 
                                ?Border.all(color: widget.currentTheme.theme.Theme_Color_ROOT)
                                :Border.all(color: Category_BorderColor_DESELECTED),
                              color: _current == index
                                ?Category_Color_SELECTED
                                :Category_Color_DESELECTED,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12,right: 10,top: 6,bottom: 6),
                              child: Text(
                                categories[index].name,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: _current == index
                                    ? Font_Color_Default
                                    :Font_Color_UNSELECTED,
                                  fontSize: Font_Color_CONTENT,
                                  fontFamily: Font_Family_LATO,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                            ),
                          ),
                        );  
                      }),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left:15, right: 15),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: 5,
                        itemBuilder: (context, index){
                          return GestureDetector(                           
                            onTap: (){
                              setState(() {
                                _contentHeight = _contentHeight == Expansion_Height_UNTAP
                                  ? Expansion_Height_TAP
                                  : Expansion_Height_UNTAP;
                              });
                            },
                            child: ContentWidget(currentTheme: widget.currentTheme,contentHeight:  _contentHeight,)
                          );
                        }),
                    ),
                  )
                ],
              )                   
            )),
          ],
        ),
    );
       
  }
}


class SearchBarWidget extends StatelessWidget{
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      right:15,
      left: 15,
      child: Container(
        height:46,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10,top: 13,bottom: 13,right: 10),
              child: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 20,
              ),
            ),
            Expanded(child: Padding(                 
              padding: const EdgeInsets.only(top: 6, bottom: 6, right: 10),//height 34
              child: Container(
                height: 34,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Color.fromRGBO(245, 245, 245, 1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                          hintText: 'Search your note',
                          border: InputBorder.none
                        ),
                        //focusNode: _focusNode,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child:const Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 20,
                      )
                    )
                  ],
                )
              )
            ))
          ],
        ),
      )
    );
  } 
}

class ContentWidget extends StatefulWidget {

  final CurrentTheme currentTheme;
  final double contentHeight;
  const ContentWidget({required this.currentTheme, required this.contentHeight, super.key});

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),    
      ),
      elevation: 2,
      child:
          ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child:         
            Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: widget.currentTheme.theme.Theme_Color_ROOT,
                    width: 7
                  )
                )
              ),
              child: Column(
                children: <Widget>[
                  ListTileTheme(
                    contentPadding: const EdgeInsets.only(left: 10),
                    dense: true,
                    horizontalTitleGap: 0.0,
                    minLeadingWidth: 0,
                    child: ExpansionTile(
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent)
                      ),
                      title: Text(
                        'hello',
                        style: TextStyle(
                          fontFamily: Font_Family_LATO,
                          fontSize: Font_Size_HEADER,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),),
                
                      trailing: IconButton(
                        onPressed: () {            
                        },
                        icon: Icon(
                          Icons.star_border,
                          size: 20,
                          color: Font_Color_UNSELECTED,
                          )
                      ),
                        //inkwellFactory: NoSplashFactory(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: 
                            Expanded(child:                             
                              Text(
                              'dio jskdj ksdjks jdk sjkdjskd jskjd skjd ksj ksjd ksjdk sjdk jskd jskd jskd jskdj',
                              style: TextStyle(
                                color: Font_Color_Default,
                                fontSize: Font_Color_CONTENT,
                                fontFamily: Font_Family_LATO,
                                fontWeight: FontWeight.w500
                              ),
                            ))

                          ,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                    child: Row(
                      children: [
                        Text('20.10.2023 13:25:32',
                          style: TextStyle(
                            color: Font_Color_SUBDOMAIN,
                            fontSize: Font_Color_CONTENT,
                            fontFamily: Font_Family_LATO
                          ),),
                        const Expanded(child: SizedBox()),
                        NotificationWidget(),
                      ]
                    ),
                  )
                ],             
              )
            )
        )
    );
  }
}

class aReminderWidget extends StatefulWidget {
  const aReminderWidget({super.key});

  @override
  State<aReminderWidget> createState() => _aReminderWidgetState();
}

class _aReminderWidgetState extends State<aReminderWidget> {
  final List<String> textList = ["reminder: 5 days", "this_is_a111111_long_text"];
  late String _currentItemSelected;
  @override
  void initState() {
    super.initState();
    _currentItemSelected = textList[0];
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context){
        return textList.map((str){
          return PopupMenuItem(
            value: str,
            height: 10,
            child: Text(
              str,
              style: TextStyle(
                fontSize: Font_Color_CONTENT,
                fontFamily: Font_Family_LATO,
                fontWeight: FontWeight.w300,
                color: Font_Color_SUBDOMAIN
              ),
            )
          );
        }).toList();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(_currentItemSelected,
            style: TextStyle(
              color: Font_Color_SUBDOMAIN,
              fontSize: Font_Color_CONTENT,
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