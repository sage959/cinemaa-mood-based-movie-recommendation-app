import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/movie.dart';
import '../services/movie_api.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../widgets/app_header.dart';
import '../widgets/movie_tile.dart';
import 'movie_details.dart';
import 'mood_picker.dart';
import 'saved_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  bool _showSearch = false;
  int _navIdx = 0;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openDetails(Movie movie) {
    context.read<MovieProvider>().trackViewed(movie);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: context.watch<ThemeNotifier>().isDark
                ? Colors.white
                : Colors.black87,
          ),
        ),
      );

  Widget _hScroll(List<Movie> movies) {
    if (movies.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
            child: CircularProgressIndicator(
                color: AppColors.accent, strokeWidth: 2)),
      );
    }
    return SizedBox(
      height: 248,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (_, i) => MovieTile(
          movie: movies[i],
          wide: true,
          onTap: () => _openDetails(movies[i]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<MovieProvider>();
    final isDark = context.watch<ThemeNotifier>().isDark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: AppHeader(
                onSearchTap: () => setState(() {
                  _showSearch = !_showSearch;
                  if (!_showSearch) _searchCtrl.clear();
                }),
              ),
            ),
            if (_showSearch)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: AppColors.textMuted),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: AppColors.textMuted),
                      onPressed: () => setState(() {
                        _showSearch = false;
                        _searchCtrl.clear();
                      }),
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.cardDark : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    if (val.length > 2) prov.runSearch(val);
                  },
                ),
              ),
            Expanded(
              child: _showSearch && _searchCtrl.text.length > 2
                  ? _buildSearchResults(prov)
                  : _buildFeed(prov),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        indicatorColor: AppColors.accent.withOpacity(0.2),
        selectedIndex: _navIdx,
        onDestinationSelected: (idx) {
          setState(() => _navIdx = idx);
          if (idx == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const MoodPickerScreen()));
          } else if (idx == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SavedListScreen()));
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.mood_rounded), label: 'Mood'),
          NavigationDestination(
              icon: Icon(Icons.bookmark_rounded), label: 'Watchlist'),
        ],
      ),
    );
  }

  Widget _buildSearchResults(MovieProvider prov) {
    if (prov.searchLoading) {
      return const Center(
          child: CircularProgressIndicator(
              color: AppColors.accent, strokeWidth: 2));
    }
    if (prov.searchResults.isEmpty) {
      return Center(
          child: Text('No results found.',
              style: GoogleFonts.poppins(color: AppColors.textMuted)));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.58,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: prov.searchResults.length,
      itemBuilder: (_, i) => MovieTile(
        movie: prov.searchResults[i],
        onTap: () => _openDetails(prov.searchResults[i]),
      ),
    );
  }

  Widget _buildFeed(MovieProvider prov) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prov.currentMood.isNotEmpty) ...[
            _sectionLabel(
                'Based on mood · ${prov.currentMood} ${moodEmojis[prov.currentMood] ?? ""}'),
            prov.isLoading
                ? const SizedBox(
                    height: 200,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.accent, strokeWidth: 2)))
                : _hScroll(prov.moodMovies),
            const SizedBox(height: 22),
          ],
          _sectionLabel('🔥 Trending Now'),
          _hScroll(prov.trendingMovies),
          const SizedBox(height: 22),
          if (prov.recentlyViewed.isNotEmpty) ...[
            _sectionLabel('🕐 Recently Viewed'),
            _hScroll(prov.recentlyViewed),
            const SizedBox(height: 22),
          ],
          if (prov.becauseYouWatched.isNotEmpty) ...[
            _sectionLabel('✨ Because You Watched'),
            _hScroll(prov.becauseYouWatched),
            const SizedBox(height: 22),
          ],
        ],
      ),
    );
  }
}
