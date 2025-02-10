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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(userName),
      body: SingleChildScrollView(
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

class MovieNewsWidget extends StatelessWidget {
  const MovieNewsWidget({
    super.key,
    required this.movieNews,
  });

  final List<Map<String, String>> movieNews;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(movieNews.length, (index) {
            final movie = movieNews[index];
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${movie['title']} tapped!")),
                );
              },
              child: Container(
                width: 200,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        movie['image']!,
                        height: 150, // Đặt chiều cao cố định
                        width: double.infinity, // Đặt chiều rộng vừa khung
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      movie['title']!,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}

class MovieNewsHeader extends StatelessWidget {
  const MovieNewsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Movie news",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // code to navigate to another screen
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Retal tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/Retal.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Retal",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("IMAX tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/Imax.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Imax",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("4DX tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/4Dx.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "4DX",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("SweetBox tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/Sweetbox.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "SweetBox",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ServiceHeader extends StatelessWidget {
  const ServiceHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Service",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // code to navigate to another screen
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PromoDiscount extends StatelessWidget {
  const PromoDiscount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Image.asset('assets/images/Discount.png'),
    );
  }
}

class PromoDiscountHeader extends StatelessWidget {
  const PromoDiscountHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 0, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Promo & Discount",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // code to navigate to another screen
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ComingSoonMovies extends StatelessWidget {
  const ComingSoonMovies({
    super.key,
    required this.comingSoon,
  });

  final Future<List<Movie>> comingSoon;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: comingSoon, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No movies available"),
          );
        }

        final movies = snapshot.data!;

        return SizedBox(
          height: 300, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 8),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return FutureBuilder<Movie>(
                future: APIserver()
                    .getMovieDetail(movie.id), // Gọi chi tiết bộ phim
                builder: (context, movieDetailSnapshot) {
                  if (movieDetailSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (movieDetailSnapshot.hasError) {
                    return Center(
                      child: Text("Error: ${movieDetailSnapshot.error}"),
                    );
                  } else if (!movieDetailSnapshot.hasData) {
                    return const Center(
                      child: Text("No movie details available"),
                    );
                  }

                  return GestureDetector(
                    onTap: () {
                    // Điều hướng tới trang chi tiết của phim
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movie: movie),
                      ),
                    );
                  },
                    child: Container(
                      width: 165, // Độ rộng cho mỗi item
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original${movie.posterPath}",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          // Tên phim
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.video,
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  movie.genres.join(", "),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, size: 14),
                              const SizedBox(width: 3),
                              Text(
                                formatDate(movie.releaseDate),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          // Hiển thị runtime dưới tên phim
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ComingSoonHeader extends StatelessWidget {
  const ComingSoonHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Coming soon",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const MainScreen(initialIndex: 2), 
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NowShowingMovies extends StatelessWidget {
  const NowShowingMovies({
    super.key,
    required this.nowShowing,
  });

  final Future<List<Movie>> nowShowing;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nowShowing,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No movies available"),
          );
        }
        final movies = snapshot.data!;

        return CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, movieIndex) {
            final movie = movies[index];

            return FutureBuilder<Movie>(
              future: APIserver().getMovieDetail(movie.id),
              builder: (context, movieDetailSnapshot) {
                if (movieDetailSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (movieDetailSnapshot.hasError) {
                  return Center(
                    child: Text("Error: ${movieDetailSnapshot.error}"),
                  );
                } else if (!movieDetailSnapshot.hasData) {
                  return const Center(
                    child: Text("No movie details available"),
                  );
                }

                final movieDetail = movieDetailSnapshot.data!;

                return GestureDetector(
                  onTap: () {
                    // Điều hướng tới trang chi tiết của phim
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(movie: movie),
                      ),
                    );
                  },

                  child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hình ảnh trong Carousel
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://image.tmdb.org/t/p/original${movie.posterPath}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Tiêu đề của phim
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            movie.title,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                  
                      // Hiển thị runtime dưới tiêu đề phim
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          Text(
                            formatRuntime(movieDetail.runtime),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Text(
                            "•", // Dấu chấm tròn
                            style: TextStyle(
                              fontSize: 18, // Thay đổi kích thước dấu chấm
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            movie.genres.join(', '),
                            style: const TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                  
                      // Đánh giá phim
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text('(${movie.voteCount})',
                                style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            enlargeCenterPage: true,
            aspectRatio: 0.75,
            scrollPhysics: const BouncingScrollPhysics(),
            enableInfiniteScroll: true,
          ),
        );
      },
    );
  }
}

class NowShowingHeader extends StatelessWidget {
  const NowShowingHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Now playing",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const MainScreen(initialIndex: 2), // 2 là tab Movies
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14)
              ],
            ),
          ),
        ],
      ),
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
  FocusNode _focusNode = FocusNode();
  APIserver _apiServer = APIserver();
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






