import 'package:flutter/material.dart';
import '../../../../core/util/constants/sizes.dart';

class RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool selected;
  final double iconSize;

  const RoundButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.selected = false,
    this.iconSize = 40.0, // Default icon size
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: dPadding * 2),
        padding: const EdgeInsets.all(dPadding * 2),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary // Use primary color when selected
              : theme.colorScheme.secondary.withOpacity(0.2), // Use secondary for unselected
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: selected
              ? theme.colorScheme.onPrimary // Icon color for selected state
              : theme.iconTheme.color, // Default icon color from theme
          size: iconSize,
        ),
      ),
    );
  }
}