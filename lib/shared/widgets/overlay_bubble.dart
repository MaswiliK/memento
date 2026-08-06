// lib/shared/widgets/overlay_bubble.dart
import 'package:flutter/material.dart';

class OverlayBubble extends StatelessWidget {
  final VoidCallback onTap;

  const OverlayBubble({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior
          .opaque, // Ensures the entire 64x64 circle captures taps cleanly
      child: Center(
        child: Container(
          width:
              56, // Adjusted slightly to give the external shadow 4dp of padding inside the 64dp window boundary
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(
                  alpha: 0.22,
                ), // Slightly increased opacity to replace blur depth
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons
                  .sticky_note_2_outlined, // Clean, minimalistic note icon for the overlay bubble
              color: Color(
                0xFF63ADCF,
              ), // Clean hex representation of your brand color
              size: 27,
            ),
          ),
        ),
      ),
    );
  }
}
