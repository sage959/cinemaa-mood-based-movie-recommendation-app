import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/movie.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final bool wide;

  const MovieTile({
    super.key,
    required this.movie,
    required this.onTap,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeNotifier>().isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: wide ? 130 : null,
        margin: wide
            ? const EdgeInsets.only(right: 12)
            : const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: movie.posterUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      height: wide ? 175 : 195,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _placeholder(wide),
                      errorWidget: (_, __, ___) => _placeholder(wide),
                    )
                  : _placeholder(wide),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.gold, size: 13),
                      const SizedBox(width: 3),
                      Text(
                        formatRating(movie.rating),
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(bool wide) => Container(
        height: wide ? 175 : 195,
        color: AppColors.cardDark,
        child: const Center(
          child: Icon(Icons.movie_rounded, color: Colors.white24, size: 36),
        ),
      );
}
