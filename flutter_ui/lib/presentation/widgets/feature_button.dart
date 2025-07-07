import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

/// Feature button with icon and label
class FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final ButtonStyle? style;

  const FeatureButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: AppConstants.smallIconSize,
              height: AppConstants.smallIconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Icon(icon, size: AppConstants.smallIconSize),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: AppTheme.cardColor,
            foregroundColor: AppTheme.textPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(color: AppTheme.borderColor),
            ),
          ),
    );
  }
}
