import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.radius = 22,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        placeholder: (_, __) => _placeholder(),
        errorWidget: (_, __, ___) => _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: RbcColors.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.image_rounded, color: RbcColors.primary),
    );
  }
}

class AppNetworkAvatar extends StatelessWidget {
  const AppNetworkAvatar({super.key, required this.url, this.size = 48});

  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: RbcColors.accent, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: AppNetworkImage(url: url, height: size, width: size, radius: size),
    );
  }
}
