import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';

/// Reusable card widget with VS Code styling
class VSCodeCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const VSCodeCard({
    super.key,
    required this.child,
    this.title,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
      child: Card(
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
