import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor prevents class to be instantiated from outside of the library.
  AppTheme._();

  // Primary colors map to components and elements, like app bars and buttons.
  // Secondary colors are most often used as accents on components, such as FABS and selection controls.
  // Color variants used to complement and provide accessible options for your primary and secondary colors.
  static const Color primaryColor = Color(0xFFCA9865);
  static const Color primaryVariantColor = Color(0xFF130904);
  static const Color secondaryColor = Color(0xFF892E0D);
  static const Color secondaryVariantColor = Color(0xFF892E0D);

  // Background color is found behind scrollable content.
  static const Color backgroundColor = Color(0xFFEFEDED);
  // Surface colors map to components such as cards, sheets, and menus.
  static const Color surfaceColor = Color(0xFFCAB9B8);
  // Error color indicates errors in components, such as text fields.
  static const Color errorColor = Color(0xFFB00020);

  // “On” colors are primarily applied to text, iconography, and strokes.
  static const Color onPrimaryColor = Color(0xFFEFEDED);
  static const Color onSecondaryColor = Color(0xFFEFEDED);
  static const Color onBackgroundColor = Color(0xFF892E0D);
  static const Color onSurfaceColor = Colors.grey;
  static const Color onErrorColor = Color(0xFFEFEDED);

  static final ThemeData appTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      primaryVariant: primaryVariantColor,
      secondary: secondaryColor,
      secondaryVariant: secondaryVariantColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
      onPrimary: onPrimaryColor,
      onSecondary: onSecondaryColor,
      onSurface: onSurfaceColor,
      onBackground: onBackgroundColor,
      onError: onErrorColor,
      brightness: Brightness.light,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
    ),
    fontFamily: 'Roboto',
    textTheme: _textTheme,
  );

  // Use https://material.io/design/typography/the-type-system.html#type-scale to build TextTheme
  static final TextTheme _textTheme = TextTheme(
    headline1: TextStyle(
      color: onBackgroundColor,
      fontSize: 96,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    headline2: TextStyle(
      color: onBackgroundColor,
      fontSize: 60,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    headline3: TextStyle(
      color: onBackgroundColor,
      fontSize: 48,
      fontWeight: FontWeight.w400,
    ),
    headline4: TextStyle(
      color: onBackgroundColor,
      fontSize: 34,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headline5: TextStyle(
      color: onBackgroundColor,
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    headline6: TextStyle(
      color: onBackgroundColor,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    subtitle1: TextStyle(
      color: onBackgroundColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    subtitle2: TextStyle(
      color: onBackgroundColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyText1: TextStyle(
      color: onBackgroundColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyText2: TextStyle(
      color: onBackgroundColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    button: TextStyle(
      color: onPrimaryColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    caption: TextStyle(
      color: onSurfaceColor,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    overline: TextStyle(
      color: onSurfaceColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  );
}
