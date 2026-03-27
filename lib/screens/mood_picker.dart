import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/movie_api.dart';
import '../utils/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/mood_chip.dart';
import 'home_screen.dart';

class MoodPickerScreen extends StatelessWidget {
  const MoodPickerScreen({super.key});

  static const _moods = [
    'Happy',
    'Sad',
    'Chill',
    'Excited',
    'Scared',
    'Curious'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              const SizedBox(height: 36),
              Text(
                'How are you\nfeeling today?',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We'll pick the perfect movies for your mood.",
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: _moods.length,
                  itemBuilder: (ctx, i) => MoodChip(
                    mood: _moods[i],
                    onTap: () {
                      ctx.read<MovieProvider>().pickMood(_moods[i]);
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
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
