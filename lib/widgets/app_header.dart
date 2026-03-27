import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utils/colors.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const AppHeader({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final t = context.watch<ThemeNotifier>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.movie_filter_rounded, color: AppColors.accent, size: 26),
            const SizedBox(width: 8),
            Text(
              'Cineमाँ',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: t.isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        Row(
          children: [
            if (onSearchTap != null)
              IconButton(
                icon: Icon(Icons.search_rounded,
                    color: t.isDark ? Colors.white70 : Colors.black54),
                onPressed: onSearchTap,
              ),
            IconButton(
              icon: Icon(
                t.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: t.isDark ? Colors.white70 : Colors.black54,
              ),
              onPressed: t.toggle,
            ),
          ],
        ),
      ],
    );
  }
}
