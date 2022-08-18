import 'package:flutter/material.dart';
import 'package:swiftbook/styles/size-config.dart';

class AppTheme {
  AppTheme._();

  static const Color bgColor = Color.fromRGBO(245, 245, 245, 1.0);
  static const Color containerColor = Colors.white;
  static const Color greenColor = Color.fromRGBO(24, 168, 30, 1.0);
  static const Color lightGreen = Color.fromRGBO(226, 248, 225, 1.0);
  static const Color logoGrey = Color.fromRGBO(112, 112, 112, 1.8);
  static const Color textColor = Color.fromRGBO(112, 112, 112, 1.7);
  static const Color iconsColor = Color.fromRGBO(112, 112, 112, 1.8);

  static final TextStyle logoNameSwift = TextStyle(
    color: AppTheme.greenColor,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 2.5 * SizeConfig.textMultiplier,
    letterSpacing: 1.0,
  );

  static final TextStyle logoNameBook = TextStyle(
    color: AppTheme.logoGrey,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 2.5 * SizeConfig.textMultiplier,
    letterSpacing: 1.0,
  );

  static final TextStyle pageTitleText = TextStyle(
    color: AppTheme.greenColor,
    fontFamily: 'Poppins',
    fontSize: 2.5 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static final TextStyle containerTitleText = TextStyle(
    color: AppTheme.textColor,
    fontFamily: 'Poppins',
    fontSize: 2.5 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle formLabelText = TextStyle(
    color: Colors.grey,
    fontFamily: 'Poppins',
    fontSize: 1.8 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle formHintText = TextStyle(
    color: AppTheme.textColor,
    fontFamily: 'Poppins',
    fontSize: 1.8 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle formInputText = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontSize: 1.8 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle inputLocationText = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontSize: 2.2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle errorTextStyle = TextStyle(
    color: Colors.red,
    fontFamily: 'Poppins',
    fontSize: 1.8 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle selectedBusDeetsText = TextStyle(
      color: Colors.black,
      fontFamily: 'Poppins',
      fontSize: 1.9 * SizeConfig.textMultiplier,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w500);

  static final TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontSize: 2 * SizeConfig.textMultiplier,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppTheme.bgColor,
    brightness: Brightness.light,
    //textTheme: textTheme,
  );

  // static final TextTheme textTheme = TextTheme(
  //   headline6: titleText,
  //   bodyText1: subtitleText,
  //   button: buttonText,
  // );
}
