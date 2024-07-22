import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maestraelena_app/Calendar/event.dart';
import 'package:maestraelena_app/Theme/app_style.dart';

class Calendar {
  late DateTime fromDate, toDate;
  List<DateTime> dayList = List.empty(growable: true);

  //start the calendar
  Calendar(DateTime fromDate_, DateTime toDate_) {
    fromDate = fromDate_;
    toDate = toDate_;
  }
  //*************************+ */
  //FUNCTION

  //this one to create a new event
  void addEvent(String name, String description, DateTime date) {
    Event newEvent = Event(name, description, date);
    //newEvent.ancorToDay;
  }

  void addDayToList(DateTime dayToAdd_) {
    dayList.add(dayToAdd_);
  }

  void printDatList() {
    print("############# DAY LIST ##############");
    for (int i = 0; i < dayList.length; i++) {
      print("${dayList[i].toString()} \n");
    }
  }
}

//******************+ */
//WIDGET SECTION

//this for the daily view widget
Widget calendarDayView(Calendar calendar) {
  return Container();
}

//this for the weekly view widget
Widget calendarWeekView(Calendar calendar) {
  return Container();
}

//this for the montly view widget
Widget calendarMonthView(Calendar calendar, DateTime today) {
  int showYear = today.year;
  int showMonth = today.month;
  DateTime firstOfMonth = DateTime(showYear, showMonth, 1);
  int startingMonthWeekday = firstOfMonth.weekday - 1; //0 = monday, 6 = sunday
  int lastMonth, lastYear;
  int nextMonth, nextYear;

  if (showMonth != 1) {
    lastMonth = showMonth - 1;
    lastYear = showYear;
  } else {
    lastMonth = 12;
    lastYear = showYear - 1;
  }

  if (showMonth != 12) {
    nextMonth = showMonth + 1;
    nextYear = showYear;
  } else {
    nextMonth = 1;
    nextYear = showYear + 1;
  }

  Widget returnRightConfigurationForMonthlyView(i, cal) {
    List<String> weekDay = List.from({'L', 'Ma', 'Me', 'G', 'V', 'S', 'D'});
    dynamic day_;
    if (i < 7) {
      return (dayInMonthView(
          true, weekDay[i], Colors.white, FontWeight.bold, 1.0));
    } else {
      if (i - 7 < startingMonthWeekday) {
        //giorni del mese precedente
        day_ = monthLength(lastMonth, lastYear) - startingMonthWeekday + i - 6;
        return (dayInMonthView(false, DateTime(lastYear, lastMonth, day_),
            paletteFirst, FontWeight.normal, 0.5));
      } else {
        day_ = i - startingMonthWeekday - 6;
        if (i - 7 <=
            monthLength(showMonth, showYear) + startingMonthWeekday - 1) {
          if (day_ == today.day) {
            return dayInMonthView(false, DateTime(showYear, showMonth, day_),
                defaultOperationColor, FontWeight.bold, 1.0);
          } else if ((i - 6) % 7 == 0) {
            return dayInMonthView(false, DateTime(showYear, showMonth, day_),
                primaryAppColor, FontWeight.bold, 1.0);
          } else {
            return dayInMonthView(false, DateTime(showYear, showMonth, day_),
                primaryAppColor, FontWeight.normal, 1.0);
          }
        } else {
          day_ =
              i - startingMonthWeekday - monthLength(showMonth, showYear) - 6;
          return dayInMonthView(false, DateTime(nextYear, nextMonth, day_),
              paletteFirst, FontWeight.normal, 0.5);
        }
      }
    }
  }

  return Container(
      margin: const EdgeInsets.only(top: 50),
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 0),
        crossAxisCount: 7, //horizontal day for a week
        children: List.generate(7 * 7, (index) {
          return Center(
              child: returnRightConfigurationForMonthlyView(index, calendar));
        }),
      ));
}

//this for the yearly view widget
Widget calendarYearView(Calendar calendar) {
  return Container();
}

//this one is the single day in the monthly view
Widget dayInMonthView(label, index, col, weight, opacity) {
  if (label) {
    return Padding(
        padding: const EdgeInsets.only(top: 12, right: 2),
        child: Container(
          alignment: Alignment.center,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "$index",
              style: GoogleFonts.comicNeue(
                color: maxDarkestAppColor,
                fontSize: 20.0,
                fontWeight: weight,
              ),
            ),
          ),
        ));
  } else {
    return Opacity(
        opacity: opacity,
        child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: col,
                  border: Border.all(width: 0.6, color: Colors.black)),
              child: GestureDetector(
                onTap: () {
                  print(index.toString());
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "${index.day}",
                    style: GoogleFonts.comicNeue(
                      color: maxDarkestAppColor,
                      fontSize: 16.0,
                      fontWeight: weight,
                    ),
                  ),
                ),
              ),
            )));
  }
}

//this one return the month lenght for a specific year (necessary for february)
int monthLength(int month, int year) {
  switch (month) {
    case 1:
      return 31;
    case 2:
      if (year % 4 == 0) {
        return 29;
      } else {
        return 28;
      }
    case 3:
      return 31;
    case 4:
      return 30;
    case 5:
      return 31;
    case 6:
      return 30;
    case 7:
      return 31;
    case 8:
      return 31;
    case 9:
      return 30;
    case 10:
      return 31;
    case 11:
      return 30;
    case 12:
      return 31;
  }
  return -1;
}
