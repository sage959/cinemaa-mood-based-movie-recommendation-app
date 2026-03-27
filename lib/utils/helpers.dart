import 'package:flutter/material.dart';

String formatRating(double r) => r.toStringAsFixed(1);

String getYear(String date) {
  if (date.length < 4) return 'N/A';
  return date.substring(0, 4);
}

const moodEmojis = {
  'Happy': '😄',
  'Sad': '😢',
  'Chill': '😎',
  'Excited': '🔥',
  'Scared': '😨',
  'Curious': '🤔',
};

const moodColors = {
  'Happy': Color(0xFFFFD60A),
  'Sad': Color(0xFF4FC3F7),
  'Chill': Color(0xFF81C784),
  'Excited': Color(0xFFFF6B35),
  'Scared': Color(0xFFAB47BC),
  'Curious': Color(0xFF26C6DA),
};
