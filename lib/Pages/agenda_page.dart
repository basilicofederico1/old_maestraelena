import 'package:flutter/material.dart';
import 'package:maestraelena_app/State/app_state.dart';
import '../Calendar/calendar.dart';
import '../Theme/app_style.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() {
    return _AgendaPage();
  }
}

class _AgendaPage extends State<AgendaPage> {
  int calendarView = 0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    const logoAR = 8 / 2;
    final topCloudOff = (58 * deviceWidth) / 300;

    return Scaffold(
      backgroundColor: homePageBackgroundColor,
      body: Stack(
        children: [
          //LOGO
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20 * homePageTopOffset / 25),
            child: AspectRatio(
              aspectRatio: logoAR,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/scrittaSolo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          //CLOUDS
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: deviceHeight / 10),
            child: AspectRatio(
              aspectRatio: 10 / 2,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/clouds.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),

          //WHITE BCK
          Container(
            margin: EdgeInsets.only(top: (deviceHeight / 10) + topCloudOff),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),

          //START CALENDAR
          Container(
              margin: EdgeInsets.only(
                  top: (deviceHeight / 7) + topCloudOff,
                  left: 24,
                  right: 24,
                  bottom: bottomBarHeight),
              alignment: Alignment.topCenter,
              child: calendarMonthView(calendar, now)),
        ],
      ),
    );
  }
}
