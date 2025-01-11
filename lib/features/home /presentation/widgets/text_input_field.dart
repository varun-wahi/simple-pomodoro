import 'package:flutter/material.dart';
import '../../../../core/util/constants/sizes.dart';

class TimeInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const TimeInputField({
    Key? key,
    required this.controller,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 70,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 35,
          color: theme.textTheme.bodyLarge?.color ?? Colors.black, // Dynamic text color
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: theme.hintColor, // Use theme's hint color
          ),
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor ?? colorScheme.surface, // Background color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(dBorderRadius),
            borderSide: BorderSide(
              color: theme.dividerColor, // Divider color for border
              width: 0.3,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(dBorderRadius),
            borderSide: BorderSide(
              color: colorScheme.primary, // Use primary color when focused
              width: 0.7,
            ),
          ),
        ),
      ),
    );
  }
}