// ignore: depend_on_referenced_packages
import 'package:html/parser.dart';

class Dwld {}

class Mltm {}

class Comm {}

class DateTime {
  late int year, month, day, hour, minute, second;

  DateTime(y, m, d, h, mi, s) {
    year = y;
    month = m;
    day = d;
    hour = h;
    minute = mi;
    second = s;
  }

  String intoString(date) {
    late String dateString;
    String monthFull = "";
    int d = date.day;
    int m = date.month;
    int y = date.year;
    int h = date.hour;
    int min = date.minute;

    switch (m) {
      case 1:
        monthFull = "Gennaio";
        break;
      case 2:
        monthFull = "Febbraio";
        break;
      case 3:
        monthFull = "Marzo";
        break;
      case 4:
        monthFull = "Aprile";
        break;
      case 5:
        monthFull = "Maggio";
        break;
      case 6:
        monthFull = "Giugno";
        break;
      case 7:
        monthFull = "Luglio";
        break;
      case 8:
        monthFull = "Agosto";
        break;
      case 9:
        monthFull = "Settembre";
        break;
      case 10:
        monthFull = "Ottobre";
        break;
      case 11:
        monthFull = "Novembre";
        break;
      case 12:
        monthFull = "Dicembre";
        break;
    }

    if (min < 10) {
      dateString = "$d $monthFull $y - $h:0$min";
    } else {
      dateString = "$d $monthFull $y - $h:$min";
    }

    return dateString;
  }
}

class Post {
  late int id;
  late Future<String> image;
  late String myImageLink;
  late bool hasImage; //ha una immagine di copertina?
  late bool hasDescription;
  double imgRatio = 16 / 9;
  late String link,
      dateStr,
      dateString,
      title,
      imageLink,
      description,
      captionLink,
      content;
  late String contentRaw;

  List<Dwld> download = List.empty(growable: true);
  List<Mltm> caption = List.empty(growable: true);
  late DateTime date;

  Post(dataJson) {
    var data = dataJson;

    id = data['id'];
    link = data['link'];
    dateStr = data['date'];
    title =
        (parse((data['title']['rendered']).toString()).documentElement!.text);
    captionLink = data['_links']['wp:attachment'][0]['href'];

    contentRaw = data['content']['rendered'];
    content =
        (parse((data['content']['rendered']).toString()).documentElement!.text);

    if (data["excerpt"]["rendered"] != "") {
      description = (parse((data["excerpt"]["rendered"]).toString())
          .documentElement!
          .text);
      hasDescription = true;
    } else {
      hasDescription = false;
      //to be tested
      description = "";
    }

    if (hasDescription && content.length <= 100) {
      content = description;
    }

    date = convertDate(dateStr);
    dateString = date.intoString(date);
  }

  DateTime convertDate(dateS) {
    //2022-11-28T09:50:05
    DateTime d = DateTime(
        int.parse(dateS.substring(0, 4)),
        int.parse(dateS.substring(5, 7)),
        int.parse(dateS.substring(8, 10)),
        int.parse(dateS.substring(11, 13)),
        int.parse(dateS.substring(14, 16)),
        int.parse(dateS.substring(17, 19)));
    return d;
  }

  bool isMoreRecent(Post b) {
    if (date.year < b.date.year) return false;
    if (date.year > b.date.year) return true;
    if (date.year == b.date.year) {
      if (date.month < b.date.month) return false;
      if (date.month > b.date.month) return true;
      if (date.month == b.date.month) {
        if (date.day < b.date.day) return false;
        if (date.day > b.date.day) return true;
        if (date.day == b.date.day) {
          if (date.hour < b.date.hour) return false;
          if (date.hour > b.date.hour) return true;
          if (date.hour == b.date.hour) {
            if (date.minute < b.date.minute) return false;
            if (date.minute > b.date.minute) return true;
            if (date.minute == b.date.minute) {
              if (date.second < b.date.second) return false;
              if (date.second > b.date.second) return true;
              if (date.second == b.date.second) {
                return true;
              }
            }
          }
        }
      }
    }
    return true;
  }
}
