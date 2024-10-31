import 'package:flutter/material.dart';
import '../../../../core/util/constants/color_grid.dart';
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
    return SizedBox(
      width: 70,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 35, color: tBlack),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(dBorderRadius),
            borderSide: const BorderSide(color: tBlack, width: 0.3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(dBorderRadius),
            borderSide: const BorderSide(color: tBlack, width: 0.7),
          ),
        ),
      ),
    );
  }
}