import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:xcell/bloc/authentication_bloc.dart';
import 'package:xcell/database/training_database.dart';
import 'package:xcell/pages/logging/logging.dart';
import 'package:xcell/pages/training/training_page1.dart';
import 'package:xcell/repository/user_repository.dart';
import 'package:xcell/theme/style.dart';

import '../linked_accounts/linked_accounts.dart';


class MyPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MyPage> {
  PageController _pageController;
  int _page = 0;
  String _username ;
  String data ;
  // String _email = "User";

  final db = DatabaseHelper.instance;
  Future<List <int>> _getPhase() async{
    return db.getLatest();
  }
  List pageTitles = [
    // "Home",
    "Training",
    "Logging",
    "Linked Accounts"
    // "Exercises",
    // "Report",
    // "Settings",
  ];
  List drawerItems = [
    // {
    //   "icon": Icons.home,
    //   "name": "Home Page",
    // },
    {
      "icon": Icons.calendar_today,
      "name": "Training Plan",
    },
    {
      "icon": Icons.fact_check_outlined,
      "name": "Logging",
    },
    {
      "icon": MaterialCommunityIcons.link_variant,
      "name": "Linked Accounts",
    },

    // {
    //   "icon": MaterialCommunityIcons.dumbbell,
    //   "name": "Exercises",
    // },
    // {
    //   "icon": Icons.stacked_bar_chart,
    //   "name": "Report",
    // },
    // {
    //   "icon": Icons.settings,
    //   "name": "Settings",
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: background,
        title: Container(
          color: background,
          child: _page == 0 ?Column(
            children: <Widget>[
              FutureBuilder<List<int>>(
                future: _getPhase(),
                builder: (BuildContext context, AsyncSnapshot<List <int>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    //print("number of days : $_day");
                    children = <Widget>[
                      Text('${pageTitles[_page]} : ',
                        style: TextStyle(fontSize: 22),
                      ),
                      Text('Phase ${snapshot.data[0]}: ',
                        style: TextStyle(fontSize: 22),
                      ),
                      Text('Week ${snapshot.data[1]}',
                        style: TextStyle(fontSize: 22),
                      ),
                    ];
                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              )
            ],
          ):
              Text(pageTitles[_page]),
        ),
      ),
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35),
            bottomRight: Radius.circular(35)),
        child: Drawer(
          child: Container(
            color: drawerBackground,
            child: ListView(
              children: <Widget>[
              Container(
                height: 220,
                child: DrawerHeader(
                  child: Column(
                    children: <Widget>[
                      Align(
                        child: IconButton(icon: Icon(Entypo.cross, color: featureColor), alignment: Alignment.centerLeft, onPressed:() => Navigator.pop(context)),
                        alignment: Alignment.centerLeft,
                      ),
                      Expanded(
                        child: Icon(Icons.person_pin_rounded,
                            size: 100
                        ),
                      ),
                      Expanded(
                        child: DefaultTextStyle(
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                            child: Text('$_username'),
                            // child: FutureBuilder<String>(
                            //   future: _username,
                            //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                            //     List<Widget> children;
                            //     if (snapshot.hasData) {
                            //       _email = snapshot.data;
                            //       children = <Widget>[
                            //         Padding(
                            //           padding: const EdgeInsets.only(top: 16),
                            //           child: Text('$_email'),
                            //         )
                            //       ];
                            //     }
                            //     return Center(
                            //       child: Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         crossAxisAlignment: CrossAxisAlignment.center,
                            //         children: children,
                            //       ),
                            //     );
                            //   },
                            // )
                        ),
                      )
                    ],
                  ),
                ),
              ),


                ListView.builder(
                  shrinkWrap: true,
                  itemCount: drawerItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map item = drawerItems[index];
                    return Padding(
                      padding: index == 5
                          ? const EdgeInsets.fromLTRB(0,240, 0, 0)
                          : const EdgeInsets.fromLTRB(0,0, 0, 0),
                      child: ListTile(
                        tileColor: _page == index
                            ? background
                            : drawerBackground,
                        leading: Icon(
                          item['icon'],
                            color:_page == index
                                ? featureColor
                                : drawerText,
                        ),
                        title: Text(
                          item['name'],
                          style: TextStyle(
                              color:_page == index
                                  ? featureColor
                                  : drawerText,
                          ),
                        ),
                        trailing: _page == index
                            ? Icon(Icons.arrow_back_ios_outlined,
                                color:_page == index
                                    ? featureColor
                                    : drawerText)
                            : Icon(Icons.arrow_forward_ios_outlined,
                                color:_page == index
                                    ? featureColor
                                    : drawerText),
                        onTap: (){
                          _pageController.jumpToPage(index);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                Container(
                  child: ListTile(
                    title: Text('Sign Out',
                      style: TextStyle(
                        color: drawerText,
                      ),
                    ),
                    selectedTileColor: background,
                    leading: Icon(Icons.logout,
                      color: drawerText,
                    ),
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(LoggedOut());
                    },
                  ),
                ),
             ],
            ),
          ),
        ),
      ),

      body: Container(
        width: screenSize(context).width,
        height: screenSize(context).height ,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: <Widget>[
            TrainingPage1(),
            LoggingPage(),
            LinkedAccountPage(),
            // TrainPage(),

            // exercisePage(),
            // reportPage(),
            // settingsPage(),


          ],
        ),
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }
  Future<void> getUsername() async {
    final String username = await UserRepository().getUsername();
    setState(() {
      _username = username;
    });

  }
  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: 0);

    // trainingApiProvider().getExerciseData();

  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
}