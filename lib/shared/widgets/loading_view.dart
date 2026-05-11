import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    this.message = 'অনুগ্রহ করে অপেক্ষা করুন...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: RbcColors.primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  color: RbcColors.primary,
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RbcColors.primary.withOpacity(.72),
                fontWeight: FontWeight.w800,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.title = 'কোনো তথ্য পাওয়া যায়নি',
    this.message = 'এই মুহূর্তে দেখানোর মতো কোনো তথ্য নেই। পরে আবার চেষ্টা করুন।',
    this.buttonText,
    this.onPressed,
    this.imagePath = 'assets/images/ad/nodata.jpg',
  });

  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: RbcColors.primary.withOpacity(.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 130,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: RbcColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RbcColors.primary.withOpacity(.64),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              if (buttonText != null && onPressed != null) ...[
                const SizedBox(height: 18),
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: RbcColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: onPressed,
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: Text(
                      buttonText!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyStateScreen extends StatelessWidget {
  const EmptyStateScreen({
    super.key,
    required this.appBarTitle,
    this.title = 'কোনো তথ্য পাওয়া যায়নি',
    this.message = 'এই মুহূর্তে দেখানোর মতো কোনো তথ্য নেই। পরে আবার চেষ্টা করুন।',
    this.buttonText,
    this.onPressed,
    this.imagePath = 'assets/images/ad/nodata.jpg',
  });

  final String appBarTitle;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          appBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffF5F7FA),
        foregroundColor: RbcColors.primary,
        surfaceTintColor: const Color(0xffF5F7FA),
      ),
      body: EmptyView(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        imagePath: imagePath,
      ),
    );
  }
}
