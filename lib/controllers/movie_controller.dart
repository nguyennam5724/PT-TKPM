import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';

class MovieController {
  final APIserver _apiServer = APIserver();
  final List<String> categories = ['Now Playing', 'Coming Soon'];
  late int selectedIndex;
  late Future<List<Movie>> nowPlayingMovies;
  late Future<List<Movie>> comingSoonMovies;

  MovieController(String initialCategory) {
    selectedIndex = categories.indexOf(initialCategory);
    loadMovies();
  }

  // Tải dữ liệu phim
  void loadMovies() {
    nowPlayingMovies = _apiServer.getNowShowing();
    comingSoonMovies = _apiServer.getComingSoon();
  }

  // Thay đổi danh mục
  void changeCategory(String category, Function setState) {
    setState(() => selectedIndex = categories.indexOf(category));
  }

  // Lấy danh sách phim dựa trên danh mục
  Future<List<Movie>> getMovies() {
    return selectedIndex == 0 ? nowPlayingMovies : comingSoonMovies;
  }

  String formatRuntime(int runtime) {
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    return '$hours hour $minutes minutes';
  }
}