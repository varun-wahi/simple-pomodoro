import 'package:flutter/material.dart';

import '../../core/util/constants/color_grid.dart';

final lightTheme = ThemeData(
    primarySwatch: Colors.orange,

    //
    //
    appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        backgroundColor: tBackground,
        centerTitle: true),

    //
    //
    textTheme: const TextTheme(bodyLarge: TextStyle(color: tBlack)),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: tBlack,
            textStyle: const TextStyle(color: tBlack))),
    dialogTheme: const DialogTheme(
      backgroundColor: tWhite,
      titleTextStyle: TextStyle(color: tBlack),
      contentTextStyle: TextStyle(color: tBlack),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
    scaffoldBackgroundColor: tWhite,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: tBlack,
        showUnselectedLabels: true,
        backgroundColor: tBackground,
        unselectedItemColor: tGreyDark,
        selectedIconTheme: IconThemeData(size: 19),
        unselectedIconTheme: IconThemeData(size: 16)

        // backgroundColor: tOrange
        ),
    listTileTheme: const ListTileThemeData(
      leadingAndTrailingTextStyle: TextStyle(color: tBlack),
      titleTextStyle: TextStyle(color: tBlack)
    ),


    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all(tBlack),
      thumbColor: WidgetStateProperty.all(tWhiteFaded),
    ),


    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: tBlack,
        foregroundColor: tWhite,
        elevation: 0.0,
        shape: CircleBorder()));
