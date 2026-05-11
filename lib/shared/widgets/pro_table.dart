import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class ProTableHeader extends StatelessWidget {
  const ProTableHeader({super.key, required this.columns});
  final List<String> columns;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: RbcColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: columns
            .map(
              (e) => Expanded(
                child: Text(
                  e,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: RbcColors.surface,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ProTableRow extends StatelessWidget {
  const ProTableRow({super.key, required this.values});
  final List<dynamic> values;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: RbcColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RbcColors.primary.withOpacity(.12)),
      ),
      child: Row(
        children: values
            .map(
              (e) => Expanded(
                child: Text(
                  '${e ?? ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: RbcColors.primary.withOpacity(.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
