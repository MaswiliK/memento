// lib/shared/widgets/overlay_note_card.dart
import 'package:flutter/material.dart';

class OverlayNoteCard extends StatelessWidget {
  final String note;
  final VoidCallback onMinimize;

  const OverlayNoteCard({
    super.key,
    required this.note,
    required this.onMinimize,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = note.trim().isEmpty;

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.18),
                Colors.white.withValues(alpha: 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.30),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                right:
                    32, // Prevents text overlapping under the minimize button
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isEmpty ? 'Nothing saved yet.' : note,
                    maxLines:
                        3, // Safe maximum line wrap for 120dp total window height
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isEmpty ? Colors.white60 : Colors.white,
                      fontSize:
                          16, // Clean, readable font size for quick glances
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: -6,
                right: -6,
                child: IconButton(
                  onPressed: onMinimize,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: const Icon(
                    Icons.minimize_rounded, // Improved visual visual indicator
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
