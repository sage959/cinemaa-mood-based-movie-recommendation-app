import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/movie_api.dart';
import '../utils/colors.dart';
import '../widgets/movie_tile.dart';
import 'movie_details.dart';

class SavedListScreen extends StatelessWidget {
  const SavedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MovieProvider>();
    final isDark = context.watch<ThemeNotifier>().isDark;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Watchlist', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? AppColors.darkBg : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: prov.favList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border_rounded, size: 68, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text('Nothing saved yet.', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text('Tap ❤️ on any movie to add it here.', style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.58, crossAxisSpacing: 10, mainAxisSpacing: 10,
              ),
              itemCount: prov.favList.length,
              itemBuilder: (_, i) {
                final m = prov.favList[i];
                return Stack(
                  children: [
                    MovieTile(
                      movie: m,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: m))),
                    ),
                    Positioned(
                      top: 6,
                      right: 10,
                      child: GestureDetector(
                        onTap: () => prov.toggleWatchlist(m),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                          padding: const EdgeInsets.all(5),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
