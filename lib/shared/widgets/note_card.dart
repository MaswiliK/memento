import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';

class NoteCard extends StatelessWidget {
  final String note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = note.trim().isEmpty;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.96, end: 1.0),
      curve: Curves.easeOut,
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),

            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),

              borderRadius: BorderRadius.circular(AppRadius.lg),

              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.2,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),

            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,

                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.96,
                        end: 1.0,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },

                child: Text(
                  isEmpty ? AppStrings.emptyState : note,
                  key: ValueKey(note),
                  textAlign: isEmpty ? TextAlign.center : TextAlign.start,
                  style: isEmpty
                      ? theme.textTheme.bodyMedium
                      : theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
