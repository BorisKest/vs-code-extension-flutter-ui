import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

/// Message display widget with code-like styling
class MessageDisplay extends StatelessWidget {
  final String title;
  final String message;
  final Color? borderColor;

  const MessageDisplay({
    super.key,
    required this.title,
    required this.message,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: borderColor ?? AppTheme.borderColor,
              width: 1,
            ),
          ),
          child: SelectableText(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textPrimary,
              fontFamily: 'Consolas, monospace',
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
