import 'package:flutter/material.dart';
import 'palette.dart';

const regular = FontWeight.normal;
const medium = FontWeight.w500;
const semiBold = FontWeight.w600;
const bold = FontWeight.w700;

// Light Text Theme

final oldLightTextTheme = ThemeData.light().textTheme;
final lightTextTheme = oldLightTextTheme.copyWith(
  headline4: oldLightTextTheme.headline4?.copyWith(
    fontFamily: 'poppins',
    fontSize: 35,
    fontWeight: regular,
    color: textColorLightTheme,
  ),
  headline5: oldLightTextTheme.headline5?.copyWith(
    fontFamily: 'poppins',
    fontSize: 25,
    fontWeight: semiBold,
    color: textColorLightTheme,
  ),
  headline6: oldLightTextTheme.headline6?.copyWith(
    fontFamily: 'poppins',
    fontSize: 18,
    fontWeight: medium,
    color: primaryColor,
  ),
  subtitle1: oldLightTextTheme.subtitle1?.copyWith(fontFamily: 'poppins'),
  subtitle2: oldLightTextTheme.subtitle2?.copyWith(
    fontFamily: 'poppins',
    fontSize: 14,
    fontWeight: regular,
    color: textColorLightTheme,
  ),
  bodyText1: oldLightTextTheme.bodyText1?.copyWith(
    fontFamily: 'poppins',
    color: textBodyColorLightTheme,
  ),
  bodyText2: oldLightTextTheme.bodyText2?.copyWith(
    fontFamily: 'poppins',
    color: textBodyColorLightTheme,
  ),
);
final lightThemeData = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: bgColorLightTheme,
  textTheme: lightTextTheme,
  //elevatedButtonTheme: elevatedButtonThemeData,
  //colorScheme: ThemeData.light().colorScheme.copyWith(secondary: secondaryColorLightTheme),
);

// Light Text Theme

final oldDarkTextTheme = ThemeData.dark().textTheme;
final darkTextTheme = oldDarkTextTheme.copyWith(
  headline4: oldDarkTextTheme.headline4?.copyWith(
    fontFamily: 'poppins',
    fontSize: 35,
    fontWeight: regular,
    color: textColorDarkTheme,
  ),
  headline5: oldDarkTextTheme.headline5?.copyWith(
    fontFamily: 'poppins',
    fontSize: 25,
    fontWeight: semiBold,
    color: textColorDarkTheme,
  ),
  headline6: oldDarkTextTheme.headline6?.copyWith(
    fontFamily: 'poppins',
    fontSize: 18,
    fontWeight: medium,
    color: primaryColor,
  ),
  subtitle1: oldDarkTextTheme.subtitle1?.copyWith(fontFamily: 'poppins'),
  subtitle2: oldDarkTextTheme.subtitle2?.copyWith(
    fontFamily: 'poppins',
    fontSize: 14,
    fontWeight: regular,
    color: textColorDarkTheme,
  ),
  bodyText1: oldDarkTextTheme.bodyText1?.copyWith(
    fontFamily: 'poppins',
    color: textBodyColorDarkTheme,
  ),
  bodyText2: oldDarkTextTheme.bodyText2?.copyWith(
    fontFamily: 'poppins',
    color: textBodyColorDarkTheme,
  ),
);
final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: bgColorDarkTheme,
  textTheme: darkTextTheme,
  //colorScheme: ThemeData.dark().colorScheme.copyWith(secondary: secondaryColorDarkTheme),
);
