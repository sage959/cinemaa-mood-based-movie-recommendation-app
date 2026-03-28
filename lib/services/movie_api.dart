import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';

const _apiKey = 'api_key'; // 🔑 replace this
const _base = 'https://api.themoviedb.org/3'; //

class MovieApi {
  static Future<List<Movie>> byGenre(int genreId) async {
    final url =
        '$_base/discover/movie?api_key=$_apiKey&with_genres=$genreId&sort_by=popularity.desc&page=1';
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final movieMap = jsonDecode(res.body);
        return (movieMap['results'] as List)
            .map((m) => Movie.fromJson(m))
            .toList();
      }
    } catch (e) {
      debugPrint('byGenre error: \$e');
    }
    return [];
  }

  static Future<List<Movie>> trending() async {
    const url = '$_base/trending/movie/week?api_key=$_apiKey';
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['results'] as List).map((m) => Movie.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint('trending error: \$e');
    }
    return [];
  }

  static Future<List<Movie>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final url =
        '$_base/search/movie?api_key=$_apiKey&query=${Uri.encodeComponent(query)}';
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data['results'] as List).map((m) => Movie.fromJson(m)).toList();
      }
    } catch (e) {
      debugPrint('search error: \$e');
    }
    return [];
  }
}

class MovieProvider extends ChangeNotifier {
  List<Movie> moodMovies = [];
  List<Movie> trendingMovies = [];
  List<Movie> searchResults = [];
  List<Movie> recentlyViewed = [];
  List<Movie> becauseYouWatched = [];
  List<Movie> favList = [];

  String currentMood = '';
  bool isLoading = false;
  bool searchLoading = false;

  static const moodGenreMap = {
    'Happy': 35,
    'Sad': 18,
    'Chill': 10749,
    'Excited': 28,
    'Scared': 27,
    'Curious': 878,
  };

  MovieProvider() {
    _init();
  }

  Future<void> _init() async {
    await loadWatchlist();
    trendingMovies = await MovieApi.trending();
    notifyListeners();
  }

  Future<void> pickMood(String mood) async {
    currentMood = mood;
    isLoading = true;
    notifyListeners();

    final gid = moodGenreMap[mood] ?? 35;
    moodMovies = await MovieApi.byGenre(gid);

    isLoading = false;
    notifyListeners();
  }

  Future<void> runSearch(String q) async {
    searchLoading = true;
    notifyListeners();
    searchResults = await MovieApi.search(q);
    searchLoading = false;
    notifyListeners();
  }

  void trackViewed(Movie movie) {
    recentlyViewed.removeWhere((m) => m.id == movie.id);
    recentlyViewed.insert(0, movie);
    if (recentlyViewed.length > 5) {
      recentlyViewed = recentlyViewed.sublist(0, 5);
    }
    if (movie.genreIds.isNotEmpty) {
      _loadBecauseYouWatched(movie.genreIds.first);
    }
    notifyListeners();
  }

  Future<void> _loadBecauseYouWatched(int genreId) async {
    becauseYouWatched = await MovieApi.byGenre(genreId);
    notifyListeners();
  }

  void toggleWatchlist(Movie movie) {
    final alreadyIn = favList.any((m) => m.id == movie.id);
    if (alreadyIn) {
      favList.removeWhere((m) => m.id == movie.id);
    } else {
      favList.add(movie);
    }
    _persistWatchlist();
    notifyListeners();
  }

  bool isSaved(int id) => favList.any((m) => m.id == id);

  Future<void> _persistWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(favList.map((m) => m.toMap()).toList());
    await prefs.setString('watchlist_v1', encoded);
  }

  Future<void> loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('watchlist_v1');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      favList = list.map((m) => Movie.fromJson(m)).toList();
      notifyListeners();
    }
  }
}
