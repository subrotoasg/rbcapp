import 'package:flutter/material.dart';

class LavaChatButton extends StatefulWidget {
  final VoidCallback onTap;
  const LavaChatButton({super.key, required this.onTap});

  @override
  State<LavaChatButton> createState() => _LavaChatButtonState();
}

class _LavaChatButtonState extends State<LavaChatButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _glowAnimation = Tween<double>(begin: 4.0, end: 24.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.5),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: _glowAnimation.value / 2,
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: widget.onTap,
              backgroundColor: Colors.redAccent,
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.forum_rounded, color: Colors.white, size: 28),
            ),
          ),
        );
      },
    );
  }
}