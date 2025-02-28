import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/moviedetails.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';
import 'package:moviego/widgets/coming_soon_header.dart';
import 'package:moviego/widgets/coming_soon_movies.dart';
import 'package:moviego/widgets/movie_news_header.dart';
import 'package:moviego/widgets/movie_news_widget.dart';
import 'package:moviego/widgets/now_showing_header.dart';
import 'package:moviego/widgets/now_showing_movies.dart';
import 'package:moviego/widgets/promo_discount.dart';
import 'package:moviego/widgets/promo_discount_header.dart';
import 'package:moviego/widgets/service_header.dart';
import 'package:moviego/widgets/service_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required void Function(int index) onTabChange});

  @override
  State<HomePage> createState() => _HomePageState();
}

String formatDate(String date) {
  try {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy').format(parsedDate);
  } catch (e) {
    return "Invalid Date";
  }
}

String formatRuntime(int runtime) {
  int hours = runtime ~/ 60;
  int minutes = runtime % 60;
  return "${hours}h${minutes}m";
}

class _HomePageState extends State<HomePage> {
  final String userName = "Son Tung MTP";
  late Future<List<Movie>> nowShowing = APIserver().getNowShowing();
  late Future<List<Movie>> comingSoon = APIserver().getComingSoon();

  final List<Map<String, String>> movieNews = [
    {
      "image": "assets/images/Mufasa.png",
      "title":
          "Box Office: ‘Mufasa’ Wins With ${23.8}M, ‘Sonic 3’ Sits at No. 2 as Franchise Crosses ${1}B Globally"
    },
    {
      "image": "assets/images/toy_story_4_-publicity_still_13-h_2019.png",
      "title": "Tim Allen Teases a “Very, Very Clever” ‘Toy Story 5’ Script"
    },
    {
      "image": "assets/images/batman.png",
      "title":
          "‘The Batman’ Sequel Moves to 2027 as Alejandro González Iñárritu and Tom Cruise Take Its Fall 2026 Date"
    },
    {
      "image":
          "assets/images/Dune-2-The-Substance-Wild-Robot-Split-Everett-H-2025.png",
      "title": "Heat Vision’s Top 10 Movies of 2024"
    },
    {
      "image":
          "assets/images/WIN_OR_LOSE-ONLINE-USE-g170_38a_pub.pub16n.448-2-H-2024.png",
      "title":
          "Ex-Pixar Staffers Decry ‘Win or Lose’ Trans Storyline Being Scrapped: “Can’t Tell You How Much I Cried”"
    },
  ];


  @override
  void initState() {
    super.initState();
    _loadData(); // Khởi tạo dữ liệu ban đầu
  }

  // Hàm tải dữ liệu từ API
  void _loadData() {
    setState(() {
      nowShowing = APIserver().getNowShowing();
      comingSoon = APIserver().getComingSoon();
    });
  }

  Future<void> _onRefresh() async {
  try {
    _loadData();
    await Future.wait([nowShowing, comingSoon]);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to refresh data: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(userName),
      body: Container(
        color: Colors.black,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: Colors.yellow,
          child: SingleChildScrollView(
            
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                const SearchBar(),
                const SizedBox(height: 20),
                const NowShowingHeader(),
                const SizedBox(
                  height: 15,
                ),
                NowShowingMovies(nowShowing: nowShowing),
                const ComingSoonHeader(),
                const SizedBox(height: 15),
                ComingSoonMovies(comingSoon: comingSoon),
                const SizedBox(height: 15),
                const PromoDiscountHeader(),
                const SizedBox(height: 5),
                const PromoDiscount(),
                const ServiceHeader(),
                const SizedBox(height: 5),
                const ServiceWidget(),
                const SizedBox(height: 10),
                const MovieNewsHeader(),
                const SizedBox(height: 5),
                MovieNewsWidget(movieNews: movieNews)
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //     padding: const EdgeInsets.all(0),
      //     decoration: const BoxDecoration(
      //         border: Border(
      //       top: BorderSide(color: Color(0xFF262626)),
      //     )),
      //     child: const CustomBottomNavBar()),
    );
  }

  AppBar buildAppBar(String userName) {
    return AppBar(
      title: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $userName',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const Text(
              'MovieGo',
              style: TextStyle(
                  fontSize: 26, color: Colors.yellow, fontFamily: "Ultra"),
            ),
          ],
        ),
      ),
      actions: [
        const Icon(
          Icons.notifications_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 20),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipOval(
            child: Image.asset(
              'assets/images/mtp.jpg',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
      elevation: 0,
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.black,
    );
  }
}


class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final APIserver _apiServer = APIserver();
  List<Movie> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Cập nhật trạng thái khi focus thay đổi
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      try {
        List<Movie> results = await _apiServer.searchMovies(query);
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isSearching = false;
        });
      }
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _searchResults = [];
    });
  }

  void _hideSearchResults() {
    setState(() {
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Nhận tất cả các sự kiện chạm
      onTap: () {
        FocusScope.of(context).unfocus(); // Đóng bàn phím
        _hideSearchResults(); // Ẩn kết quả tìm kiếm
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(FeatherIcons.search, color: Colors.white),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: _clearSearch,
                      )
                    : null,
                hintText: 'Search movies...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
                filled: true,
                fillColor: Colors.grey[900],
              ),
              onChanged: _onSearchChanged,
              onTap: () {
                // Không làm gì khi nhấn vào TextField
              },
            ),
          ),
          if (_searchResults.isNotEmpty)
            GestureDetector(
              onTap: () {
                // Ngăn chặn đóng danh sách khi nhấn vào trong danh sách
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                constraints: const BoxConstraints(
                  maxHeight: 300, // Giới hạn chiều cao danh sách kết quả
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8)
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: _searchResults.map((movie) {
                      return ListTile(
                        
                        leading: Image.network(
                          "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                          fit: BoxFit.cover,
                        ),
                        title: Text(movie.title,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          movie.genres.join(", "),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(movie: movie),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          if (_isSearching)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}






