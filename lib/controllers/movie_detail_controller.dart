// controllers/movie_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailController {
  final Movie movie;
  int selectedIndex = -1; // Rạp chiếu được chọn
  int selectedStars = 0; // Số sao đánh giá

  final List<Map<String, String>> cinemaList = [
    {"name": "Vincom Ocean Park CGV", "address": "Da Ton, Gia Lam, Ha Noi", "image": "assets/images/cgv.png"},
    {"name": "Lotte Cinema Long Bien", "address": "7-9 Nguyen Van Linh, Long Bien, Ha Noi", "image": "assets/images/lotte.png"},
    {"name": "Beta Cinemas Thanh Xuan", "address": "Thanh Xuan, Ha Noi", "image": "assets/images/lotte.png"},
    {"name": "Galaxy Cinema Nguyen Du", "address": "Hoan Kiem, Ha Noi", "image": "assets/images/cgv.png"},
  ];

  final APIserver _apiServer = APIserver();

  MovieDetailController({required this.movie}) {
    loadSelectedStars();
  }

  // Tải số sao đánh giá từ SharedPreferences
  Future<void> loadSelectedStars() async {
    final prefs = await SharedPreferences.getInstance();
    selectedStars = prefs.getInt('selectedStars_${movie.id}') ?? 0;
  }

  // Lưu số sao đánh giá vào SharedPreferences
  Future<void> saveSelectedStars(int stars, Function setState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedStars_${movie.id}', stars);
    setState(() => selectedStars = stars);
  }

  // Chọn rạp chiếu
  void selectCinema(int index, Function setState) {
    setState(() => selectedIndex = index);
  }

  // Lấy chi tiết phim từ API
  Future<Movie> getMovieDetails() {
    return _apiServer.getMovieDetail(movie.id);
  }

  // Lấy URL trailer
  Future<String?> getTrailerUrl() {
    return _apiServer.getMovieTrailer(movie.id);
  }

  String convertToEmbedUrl(String url) {
    final videoId = Uri.parse(url).queryParameters['v'];
    return videoId != null
        ? 'https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&showinfo=0&rel=0&modestbranding=1'
        : url;
  }

  String formatRuntime(int runtime) {
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    return '$hours hour $minutes minutes';
  }

  String formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('dd.MM.yyyy').format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }
}