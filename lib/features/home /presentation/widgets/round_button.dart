import 'package:flutter/material.dart';
import '../../../../core/util/constants/color_grid.dart';
import '../../../../core/util/constants/sizes.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool selected;

  const RoundButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: dPadding * 2),
        padding: const EdgeInsets.all(dPadding * 2),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.blueGrey.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: selected ? tWhite : tBlack, size: 40),
      ),
    );
  }
}