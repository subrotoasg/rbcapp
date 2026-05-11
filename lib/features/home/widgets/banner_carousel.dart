import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rbc_flutter_professional/core/theme/app_colors.dart';
import 'package:rbc_flutter_professional/shared/widgets/loading_view.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.future,
    this.height,
    this.borderRadius = 24,
    this.margin = EdgeInsets.zero,
    this.autoPlay = true,
  });

  final Future<List<dynamic>> future;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry margin;
  final bool autoPlay;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _pageController;
  Timer? _timer;

  int index = 0;
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.future != widget.future) {
      _timer?.cancel();
      _timer = null;
      _itemCount = 0;
      index = 0;

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay(int length) {
    if (!widget.autoPlay || length <= 1) return;

    if (_timer?.isActive == true && _itemCount == length) return;

    _itemCount = length;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients || _itemCount <= 1) return;

      final nextPage = (index + 1) % _itemCount;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  String _imageUrl(dynamic item) {
    if (item is Map) {
      return '${item['url'] ?? item['image'] ?? item['banner'] ?? item['photo'] ?? ''}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final sliderHeight = widget.height ?? MediaQuery.sizeOf(context).height;

    return FutureBuilder<List<dynamic>>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: sliderHeight,
            margin: widget.margin,
            alignment: Alignment.center,
            child: const LoadingView(),
          );
        }

        if (snapshot.hasError) {
          return _ErrorSlider(
            height: sliderHeight,
            margin: widget.margin,
            borderRadius: widget.borderRadius,
          );
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) return const SizedBox.shrink();

        _startAutoPlay(data.length);

        return Container(
          height: sliderHeight,
          width: double.infinity,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.14),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: data.length,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (v) {
                    setState(() => index = v);
                  },
                  itemBuilder: (context, i) {
                    final url = _imageUrl(data[i]);

                    if (url.isEmpty) {
                      return const _EmptyImageView();
                    }

                    return _ProfessionalBannerImage(
                      url: url,
                      height: sliderHeight,
                    );
                  },
                ),

                // Dots indicator only
                if (data.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.paddingOf(context).bottom + 18,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        data.length,
                        (i) {
                          final selected = i == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 280),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: selected ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: selected
                                  ? RbcColors.accent
                                  : Colors.white.withOpacity(.80),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Colors.black.withOpacity(.08),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfessionalBannerImage extends StatelessWidget {
  const _ProfessionalBannerImage({
    required this.url,
    required this.height,
  });

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _EmptyImageView(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(10),
          child: Image.network(
            url,
            height: height,
            width: double.infinity,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return const Center(
                child: LoadingView(),
              );
            },
            errorBuilder: (_, __, ___) => const _EmptyImageView(),
          ),
        ),
      ],
    );
  }
}

class _EmptyImageView extends StatelessWidget {
  const _EmptyImageView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.white54,
        size: 42,
      ),
    );
  }
}

class _ErrorSlider extends StatelessWidget {
  const _ErrorSlider({
    required this.height,
    required this.margin,
    required this.borderRadius,
  });

  final double height;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Icon(
        Icons.broken_image_outlined,
        color: Colors.white54,
        size: 42,
      ),
    );
  }
}