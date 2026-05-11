import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class ProCard extends StatelessWidget {
  const ProCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.highlight = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: highlight ? RbcColors.primary : RbcColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: highlight ? RbcColors.accent.withOpacity(.55) : RbcColors.primary.withOpacity(.10),
        ),
        boxShadow: [
          BoxShadow(
            color: RbcColors.primary.withOpacity(.10),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: content,
    );
  }
}
