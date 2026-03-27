import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/helpers.dart';

class MoodChip extends StatelessWidget {
  final String mood;
  final VoidCallback onTap;

  const MoodChip({super.key, required this.mood, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = moodColors[mood] ?? Colors.grey;
    final emoji = moodEmojis[mood] ?? '🎬';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color, width: 1.8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 38)),
            const SizedBox(height: 10),
            Text(
              mood,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
