import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/movie.dart';
import '../services/movie_api.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MovieProvider>();
    final isDark = context.watch<ThemeNotifier>().isDark;
    final saved = prov.isSaved(movie.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBg : Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: movie.posterUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.cardDark),
                      errorWidget: (_, __, ___) => Container(color: AppColors.cardDark),
                    )
                  : Container(color: AppColors.cardDark),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        formatRating(movie.rating),
                        style: GoogleFonts.poppins(fontSize: 15, color: AppColors.gold, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 18),
                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(getYear(movie.releaseDate), style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Overview',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview.isNotEmpty ? movie.overview : 'No overview available.',
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textMuted, height: 1.65),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(saved ? Icons.bookmark_rounded : Icons.bookmark_add_outlined),
                      label: Text(
                        saved ? 'Remove from Watchlist' : 'Add to Watchlist',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: saved ? Colors.grey[700] : AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      onPressed: () => prov.toggleWatchlist(movie),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
