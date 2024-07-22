import 'package:flutter/material.dart';

late double deviceWidth;
late double deviceHeight;

Color paletteFirst = const Color.fromARGB(255, 254, 250, 234);
Color paletteSecond = const Color.fromARGB(255, 246, 221, 110);
Color paletteThird = const Color.fromARGB(255, 255, 226, 191);
Color paletteFourth = const Color.fromARGB(255, 234, 151, 83);
Color paletteFifth = const Color.fromARGB(255, 66, 21, 4);
Color paletteSixth = const Color.fromARGB(255, 182, 208, 138);
Color paletteSeventh = const Color.fromARGB(255, 120, 187, 143);
Color paletteEighth = const Color.fromARGB(255, 55, 123, 71);
Color paletteNineth = const Color.fromARGB(255, 175, 224, 243); //approved
Color paletteTenth = const Color.fromARGB(255, 13, 33, 58); //approved

//General setting
final Color primaryAppColor = paletteNineth;
final Color maxDarkestAppColor = paletteTenth;
final Color defaultOperationColor = paletteFourth;
const String websiteUrl = "https://maestraelena.com";
const int standardTransitionDuration = 600;
const Curve standardCurveTransition = Curves.easeOutCubic;

//bottom BAR
final Color bottomBarColor = paletteThird;
final Color bottomBarBorderColor = paletteFifth;
final double bottomBarHeight = deviceHeight / 13;
const double bottomBarBorderWidth = 0.8;
final double bottomBarUnselectedIconSize = deviceHeight / 25;
final double bottomBarSelectedIconSize = deviceHeight / 22;
const String bottomBarFirstIconLable = "Prodotti";
const String bottomBarSecondIconLable = "Blog";
const String bottomBarThirdIconLable = "Agenda Digitale";
final double bottomBarUnselectedFontSize = deviceHeight / 80;
final double bottomBarSelectedFontSize = deviceHeight / 75;

//homePage
final Color homePageBackgroundColor = paletteNineth;
final Color homePageTitleColor = maxDarkestAppColor;
const double homePageTitleSize = 18.0;
final homePageTopOffset = deviceHeight / 20;
const homePageTopImageAspectRatio = 5 / 4;
final homePageTopImageHeight = deviceWidth / homePageTopImageAspectRatio;
const homePageTopLogoAspectRatio = 8 / 2;
final homePageTopCloudsOffset = (58 * deviceWidth) / 300;

//post scroll box
final Color postSquareBorderColor = maxDarkestAppColor;
Color postSquareTitleColor = maxDarkestAppColor;
Color postSquareDateColor = primaryAppColor;
Color postSquareDescriptionColor = maxDarkestAppColor;
const double postSquareBorderWidth = 0.7;
double postSquareTitleSize = 20;
double postSquareDateSize = 14;
double postSquareDescriptionSize = 15.2;
