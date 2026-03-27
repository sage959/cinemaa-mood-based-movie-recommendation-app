# Cineमाँ 🎬
> Movies that match your mood.

A Flutter-based mood-driven movie recommendation app powered by TMDB API.

## Features
- 🎭 Mood-based movie recommendations (Happy, Sad, Chill, Excited, Scared, Curious)
- 🔥 Trending movies section
- 🕐 Recently viewed tracking
- ✨ "Because You Watched" smart recommendations
- 🔍 Live movie search
- ❤️ Watchlist with local persistence (SharedPreferences)
- 🌗 Dark / Light theme toggle

## Setup
1. Clone the repo
2. Get a free TMDB API key at https://www.themoviedb.org/
3. Replace `YOUR_TMDB_API_KEY` in `lib/services/movie_api.dart`
4. Run `flutter pub get`
5. Run `flutter run`

## Tech Stack
- Flutter + Dart
- Provider (state management)
- SharedPreferences (local storage)
- TMDB REST API
- cached_network_image
- google_fonts (Poppins)

## Project Structure
```
lib/
├── main.dart
├── models/movie.dart
├── services/movie_api.dart
├── screens/
│   ├── home_screen.dart
│   ├── mood_picker.dart
│   ├── movie_details.dart
│   └── saved_list.dart
├── widgets/
│   ├── app_header.dart
│   ├── mood_chip.dart
│   └── movie_tile.dart
└── utils/
    ├── colors.dart
    └── helpers.dart
```
