import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class NoteCard extends StatelessWidget {
  final String note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = note.trim().isEmpty;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 350),
      tween: Tween(begin: .98, end: 1),
      curve: Curves.easeOut,
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: .15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .22),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                isEmpty ? AppStrings.emptyState : note,
                key: ValueKey(note),
                style: isEmpty
                    ? theme.textTheme.bodyMedium
                    : theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
