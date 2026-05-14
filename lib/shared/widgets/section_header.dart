// import 'package:flutter/material.dart';
// import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

// class SectionHeader extends StatelessWidget {
//   const SectionHeader({
//     super.key,
//     required this.title,
//     this.subtitle,
//     this.actionText,
//     this.onAction,
//   });

//   final String title;
//   final String? subtitle;
//   final String? actionText;
//   final VoidCallback? onAction;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: RbcColors.primary,
//                   fontSize: 19,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               if (subtitle != null) ...[
//                 const SizedBox(height: 3),
//                 Text(
//                   subtitle!,
//                   style: TextStyle(
//                     color: RbcColors.primary.withOpacity(.62),
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         if (actionText != null && onAction != null)
//           TextButton(onPressed: onAction, child: Text(actionText!)),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: RbcColors.primary,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: RbcColors.primary.withOpacity(.62),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionText != null && onAction != null)
          // --- প্রফেশনাল বাটন ডিজাইনটি এখানে যোগ করা হয়েছে ---
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              backgroundColor: RbcColors.primary.withOpacity(.08), // হালকা ব্যাকগ্রাউন্ড কালার
              foregroundColor: RbcColors.primary, // টেক্সট কালার
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100), // গোলাকার বাটন
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12, // ছোট একটি অ্যারো আইকন
                  color: RbcColors.primary.withOpacity(.8),
                ),
              ],
            ),
          ),
      ],
    );
  }
}