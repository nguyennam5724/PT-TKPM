import 'package:flutter/material.dart';

import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/homepage.dart';
import 'package:moviego/screens/select_seat.dart';
import 'package:moviego/widgets/censorship.dart';
import 'package:moviego/widgets/credits.dart';
import 'package:moviego/widgets/dialog_helper.dart';
import 'package:moviego/widgets/genres.dart';
import 'package:moviego/widgets/language.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

String _convertToEmbedUrl(String url) {
  final videoId = Uri.parse(url).queryParameters['v'];
  if (videoId != null) {
    return 'https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&showinfo=0&rel=0&modestbranding=1';
  }
  return url; // Nếu không phải URL hợp lệ, trả về URL gốc
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int _selectedIndex = -1;
  int _selectedStars = 0;

  final List<Map<String, String>> cinemaList = [
    {
      "name": "Vincom Ocean Park CGV",
      "address": "Da Ton, Gia Lam, Ha Noi",
      "image": "assets/images/cgv.png"
    },
    {
      "name": "Lotte Cinema Long Bien",
      "address": "7-9 Nguyen Van Linh, Long Bien, Ha Noi",
      "image": "assets/images/lotte.png"
    },
    {
      "name": "Beta Cinemas Thanh Xuan",
      "address": "Thanh Xuan, Ha Noi",
      "image": "assets/images/lotte.png"
    },
    {
      "name": "Galaxy Cinema Nguyen Du",
      "address": "Hoan Kiem, Ha Noi",
      "image": "assets/images/cgv.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedStars(); 
  }

  Future<void> _loadSelectedStars() async {
    final prefs = await SharedPreferences.getInstance();
    int stars = prefs.getInt('selectedStars_${widget.movie.id}') ?? 0;

    if (stars != _selectedStars) {
      setState(() {
        _selectedStars = stars;
      });
    }
  }

  // Hàm lưu trạng thái sao cho bộ phim hiện tại
  Future<void> _saveSelectedStars(int stars) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedStars_${widget.movie.id}', stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: APIserver().getMovieDetail(widget.movie.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No details available"));
          }

          final movieDetail = snapshot.data!;

          return Stack(
            children: [
              Image.network(
                "https://image.tmdb.org/t/p/original${movieDetail.backDropPath}",
                height: 300, 
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (contex,error, stackTrace) {
                  return Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Center(
                      child: Text("No Image Available",style: TextStyle(color: Colors.amber,fontSize: 18),),
                      
                    ),
                  );
                },
              ),
              SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 180.0, left: 16, right: 16),
                    child: Column(
                      children: [
                        buildInfor1(movieDetail, context),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Genres(movieDetail: movieDetail),
                            const SizedBox(
                              height: 7,
                            ),
                            Censorship(movieDetail: movieDetail),
                            const SizedBox(
                              height: 7,
                            ),
                            Language(movieDetail: movieDetail),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Storyline",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ReadMoreText(
                              movieDetail.overview,
                              style: const TextStyle(fontSize: 16),
                              trimLines: 4,
                              trimLength: 150,
                              colorClickableText: Colors.yellow,
                              trimMode: TrimMode.Length,
                              trimCollapsedText: 'See more',
                              trimExpandedText: ' See less',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Credits(movieDetail: movieDetail),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Cinema",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            buildCinema(),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15 ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCC434),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    if (_selectedIndex == -1) {
                                      DialogHelper.showCustomDialog(
                                          context,
                                          "Thông báo",
                                          "Vui lòng chọn rạp chiếu phim trước khi tiếp tục!");
                                    } else {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              SelectSeat(
                                            movieTitle: movieDetail.title,
                                            movieRuntime: movieDetail.runtime,
                                            cinemaName:
                                                cinemaList[_selectedIndex]
                                                    ["name"]!,
                                            cinemaAddress:
                                                cinemaList[_selectedIndex]
                                                    ["address"]!,
                                            cinemaImage:
                                                cinemaList[_selectedIndex]
                                                    ["image"]!,
                                            moviePoster: movieDetail.posterPath,
                                            genres: movieDetail.genres,
                                          ),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  StatefulBuilder buildCinema() {
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: List.generate(cinemaList.length, (index) {
          return cinema(setState, index);
        }),
      );
    });
  }

  GestureDetector cinema(StateSetter setState, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: _selectedIndex == index
                ? const Color(0xFF261D08)
                : const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _selectedIndex == index
                  ? const Color(0xFFFCC434)
                  : Colors.transparent,
              width: 2,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cinemaList[index]["name"]!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    cinemaList[index]["address"]!,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 30, // Giới hạn chiều rộng của ảnh
              child: Image.asset(
                cinemaList[index]["image"]!,
                fit: BoxFit.cover, // Đảm bảo ảnh không bị cắt
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildInfor1(Movie movieDetail, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20), // Giảm padding để gọn hơn
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12), // Bo góc mềm mại hơn
      color: const Color(0xFF1C1C1C).withOpacity(0.9), // Nền mờ nhẹ
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề phim
        Text(
          movieDetail.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        
        // Thời lượng và ngày phát hành
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              formatRuntime(movieDetail.runtime),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              formatDate(movieDetail.releaseDate), // Sử dụng movieDetail thay vì widget.movie
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Đánh giá tổng quan
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "Review",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.yellow, size: 18),
                const SizedBox(width: 4),
                Text(
                  movieDetail.voteAverage.toStringAsFixed(1), // Sử dụng movieDetail
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${movieDetail.voteCount})',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Flexible(
              child: StatefulBuilder(
                builder: (context, setStarState) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setStarState(() {
                            _selectedStars = index + 1;
                          });
                          _saveSelectedStars(index + 1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.star,
                            color: index < _selectedStars
                                ? const Color(0xFFFCC434)
                                : const Color(0xFF575757),
                            size: 28, 
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final trailerUrl = await APIserver().getMovieTrailer(movieDetail.id);

                if (trailerUrl != null) {
                  final embedUrl = _convertToEmbedUrl(trailerUrl);

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Scaffold(
                        appBar: AppBar(
                          title: const Text("Trailer"),
                          automaticallyImplyLeading: false,
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        body: WebViewWidget(
                          controller: WebViewController()
                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                            ..loadRequest(Uri.parse(embedUrl)),
                        ),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Không tìm thấy trailer!'),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.play_circle_filled,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                "Trailer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFCC434), 
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
}
