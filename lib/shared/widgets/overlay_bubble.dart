// lib/shared/widgets/overlay_bubble.dart
import 'dart:ui';

import 'package:flutter/material.dart';

class OverlayBubble extends StatelessWidget {
  final VoidCallback onTap;

  const OverlayBubble({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.17),
                  Colors.white.withValues(alpha: 0.06),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 18,
                  spreadRadius: 0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.sticky_note_2_outlined,
                color: const Color.fromARGB(
                  255,
                  99,
                  173,
                  207,
                ).withValues(alpha: 0.92),
                size: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
