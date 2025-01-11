import 'package:flutter/material.dart';

import '../../core/util/constants/color_grid.dart';

final darkTheme = ThemeData(
  primarySwatch: Colors.deepOrange, // A darker swatch for dark mode
  brightness: Brightness.dark, // Ensures that the app uses dark mode

  //
  //
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0,
    backgroundColor: tBlack, // Dark background for app bar
    centerTitle: true,
    iconTheme: IconThemeData(color: tWhite), // White icons for contrast
    titleTextStyle: TextStyle(
      color: tWhite,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  //
  //



  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: tWhite, // White text for visibility
      textStyle: const TextStyle(color: tWhite),
    ),
  ),

  listTileTheme: const ListTileThemeData(
    leadingAndTrailingTextStyle: TextStyle(color: tWhite),
      titleTextStyle: TextStyle(color: tWhite)

  ),

    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.all(tWhiteFaded),
      thumbColor: WidgetStateProperty.all(tBlack),
    ),


  dialogTheme: const DialogTheme(
    backgroundColor: tGreyDark, // Darker background for dialogs
    titleTextStyle: TextStyle(color: tWhite, fontSize: 18, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: tWhite, fontSize: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),

  scaffoldBackgroundColor: tBlack, // Overall dark background for scaffold
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: tOrange, // Highlighted items in orange
    unselectedItemColor: tGreyLight, // Muted color for unselected items
    showUnselectedLabels: true,
    backgroundColor: tGreyDark, // Dark background for bottom navigation
    selectedIconTheme: IconThemeData(size: 19),
    unselectedIconTheme: IconThemeData(size: 16),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: tOrange, // Orange FAB for visibility
    foregroundColor: tBlack, // Black icon on orange FAB
    elevation: 0.0,
    shape: CircleBorder(),
  ),

  cardColor: tGreyDark, // For cards and containers
  dividerColor: tGreyLight, // Subtle dividers in the UI
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: tWhite), // Default text color for large text
    bodyMedium: TextStyle(color: tWhite), // Default text color for medium text
    bodySmall: TextStyle(color: tGreyLight), // Muted text for smaller UI elements
  ),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: tGreyDark, // Background for input fields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: tGreyLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(color: tOrange),
    ),
    hintStyle: TextStyle(color: tGreyLight),
    labelStyle: TextStyle(color: tWhite),
  ),
);