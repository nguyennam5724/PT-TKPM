import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';

class HomeController {
  final APIserver _apiServer = APIserver();
  late Future<List<Movie>> nowShowing;
  late Future<List<Movie>> comingSoon;
  final String userName = "Son Tung MTP";

  final List<Map<String, String>> movieNews = [
    {
      "image": "assets/images/Mufasa.png",
      "title": "Box Office: ‘Mufasa’ Wins With \$23.8M, ‘Sonic 3’ Sits at No. 2 as Franchise Crosses \$1B Globally"
    },
    {
      "image": "assets/images/toy_story_4_-publicity_still_13-h_2019.png",
      "title": "Tim Allen Teases a “Very, Very Clever” ‘Toy Story 5’ Script"
    },
    {
      "image": "assets/images/batman.png",
      "title": "‘The Batman’ Sequel Moves to 2027 as Alejandro González Iñárritu and Tom Cruise Take Its Fall 2026 Date"
    },
    {
      "image": "assets/images/Dune-2-The-Substance-Wild-Robot-Split-Everett-H-2025.png",
      "title": "Heat Vision’s Top 10 Movies of 2024"
    },
    {
      "image": "assets/images/WIN_OR_LOSE-ONLINE-USE-g170_38a_pub.pub16n.448-2-H-2024.png",
      "title": "Ex-Pixar Staffers Decry ‘Win or Lose’ Trans Storyline Being Scrapped: “Can’t Tell You How Much I Cried”"
    },
  ];

  HomeController() {
    loadData();
  }

  // Tải dữ liệu từ API
  void loadData() {
    nowShowing = _apiServer.getNowShowing();
    comingSoon = _apiServer.getComingSoon();
  }

  // Làm mới dữ liệu
  Future<void> onRefresh(Function setState) async {
    try {
      setState(() {
        nowShowing = _apiServer.getNowShowing();
        comingSoon = _apiServer.getComingSoon();
      });
      await Future.wait([nowShowing, comingSoon]);
    } catch (e) {
      throw Exception("Failed to refresh data: $e");
    }
  }
}