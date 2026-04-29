import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated 3-dot typing indicator with neon glow, shown while AI generates.
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Stagger each dot by 0.2
              final delay = index * 0.2;
              final value = (_controller.value - delay).clamp(0.0, 1.0);
              // Bounce curve
              final bounce = (1.0 - (2.0 * value - 1.0).abs()).clamp(0.0, 1.0);
              final opacity = 0.3 + 0.7 * bounce;
              final offset = -4.0 * bounce;

              return Container(
                margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
                child: Transform.translate(
                  offset: Offset(0, offset),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accent,
                            AppColors.neonCyan,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonCyan.withValues(alpha: 0.3 * bounce),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
