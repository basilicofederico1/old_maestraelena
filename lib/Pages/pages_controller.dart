import 'package:flutter/material.dart';
import 'package:maestraelena_app/Pages/agenda_page.dart';
import 'package:maestraelena_app/Pages/development_page.dart';
import 'package:maestraelena_app/Pages/temporary_page.dart';
import 'package:maestraelena_app/State/app_state.dart';
import 'package:maestraelena_app/Theme/app_style.dart';

import 'homepage.dart';
import 'storepage.dart';

class PagesController extends StatefulWidget {
  const PagesController({super.key});
  @override
  State<PagesController> createState() {
    return _PagesController();
  }
}

class _PagesController extends State<PagesController> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateDevState() async {
    bool lastDevState = devStateActive;
    do {
      await Future.delayed(const Duration(seconds: 1));
    } while (!devCheckEnded);

    if (lastDevState != devStateActive) {
      setState(() {
        //
      });
    }
  }

  Widget imageIcon(upperImage, lowerImage, myIndex) {
    bool myTurn;

    if (myIndex == _selectedIndex) {
      myTurn = true;
    } else {
      myTurn = false;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: standardTransitionDuration),
      curve: standardCurveTransition,
      height: myTurn ? bottomBarSelectedIconSize : bottomBarUnselectedIconSize,
      width: myTurn ? bottomBarSelectedIconSize : bottomBarUnselectedIconSize,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: myTurn ? AssetImage(upperImage) : AssetImage(lowerImage),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    if (appStateFirstLaunch) {
      updateDevState();
      appStateFirstLaunch = false;
    }

    if (!devStateActive) {
      final List<Widget> widgetOptions;

      if (agendaPageDebug) {
        widgetOptions = <Widget>[
          const StorePage(),
          const HomePage(),
          const AgendaPage(),
        ];
      } else {
        widgetOptions = <Widget>[
          const StorePage(),
          const HomePage(),
          const TemporaryPage("AGENDA DIGITALE"),
        ];
      }
      return Container(
          color: bottomBarColor,
          child: SafeArea(
              top: false,
              right: false,
              left: false,
              bottom: true,
              child: Scaffold(
                bottomNavigationBar: Container(
                  height: bottomBarHeight,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              width: bottomBarBorderWidth,
                              color: bottomBarBorderColor))),
                  child: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: imageIcon("assets/images/upper_store_icon.png",
                            "assets/images/lower_store_icon.png", 0),
                        label: bottomBarFirstIconLable,
                      ),
                      BottomNavigationBarItem(
                        icon: imageIcon("assets/images/upper_home_icon.png",
                            "assets/images/lower_home_icon.png", 1),
                        label: bottomBarSecondIconLable,
                      ),
                      BottomNavigationBarItem(
                        icon: imageIcon("assets/images/upper_planner_icon.png",
                            "assets/images/lower_planner_icon.png", 2),
                        label: bottomBarThirdIconLable,
                      ),
                    ],
                    backgroundColor: bottomBarColor,
                    currentIndex: _selectedIndex,
                    elevation: 0,
                    fixedColor: Colors.black,
                    selectedLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: bottomBarSelectedFontSize),
                    unselectedLabelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: bottomBarUnselectedFontSize),
                    onTap: _onItemTapped,
                    enableFeedback: false,
                  ),
                ),
                body: Center(
                  child: widgetOptions.elementAt(_selectedIndex),
                ),
              )));
    } else {
      return const DevelopmentPage();
    }
  }
}
