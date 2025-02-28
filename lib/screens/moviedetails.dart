import 'package:flutter/material.dart';

import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/homepage.dart';
import 'package:moviego/screens/select_seat.dart';
import 'package:moviego/widgets/dialog_helper.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  @override
  void initState() {
    super.initState();
    _loadSelectedStars(); // Tải trạng thái đã lưu khi khởi tạo
  }

  // Hàm tải trạng thái sao đã lưu cho bộ phim hiện tại
  Future<void> _loadSelectedStars() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedStars = prefs.getInt('selectedStars_${widget.movie.id}') ??
          0; // Lấy giá trị hoặc mặc định là 0
    });
  }

  // Hàm lưu trạng thái sao cho bộ phim hiện tại
  Future<void> _saveSelectedStars(int stars) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedStars_${widget.movie.id}',
        stars); // Lưu số sao đã chọn cho bộ phim này
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
                height: 300, // Chiều cao cố định của ảnh
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                child: Padding(
                    padding:
                        const EdgeInsets.only(top: 180.0, left: 16, right: 16),
                    child: Column(
                      children: [
                        Container(
                          // Nền mờ cho chữ
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFF1C1C1C),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieDetail.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    formatRuntime(movieDetail.runtime),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  const Text(" • ",
                                      style: TextStyle(color: Colors.white)),
                                  Text(
                                    formatDate(widget.movie.releaseDate),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const Text("Review",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.movie.voteAverage.toStringAsFixed(1),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${widget.movie.voteCount})',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: List.generate(5, (index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 2.0),
                                        child: SizedBox(
                                          width: 32,
                                          child: IconButton(
                                            icon: Icon(
                                              index < _selectedStars
                                                  ? Icons.star
                                                  : Icons.star,
                                              color: index < _selectedStars
                                                  ? const Color(0xFFFCC434)
                                                  : const Color(0xFF575757),
                                              size: 34,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _selectedStars = index + 1;
                                              });
                                              _saveSelectedStars(index + 1);
                                            },
                                            padding: const EdgeInsets.all(0),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  // Nút xem trailer
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFFBFBFBF),
                                      ),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        // Gọi API để lấy URL trailer
                                        final trailerUrl = await APIserver()
                                            .getMovieTrailer(movieDetail.id);

                                        if (trailerUrl != null) {
                                          final embedUrl =
                                              _convertToEmbedUrl(trailerUrl);

                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.8,
                                              child: Scaffold(
                                                appBar: AppBar(
                                                  title: const Text("Trailer"),
                                                  automaticallyImplyLeading:
                                                      false,
                                                  actions: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                body: WebViewWidget(
                                                  controller:
                                                      WebViewController()
                                                        ..setJavaScriptMode(
                                                            JavaScriptMode
                                                                .unrestricted)
                                                        ..loadRequest(Uri.parse(
                                                            embedUrl)),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          // Hiển thị thông báo nếu không tìm thấy trailer
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Không tìm thấy trailer!'),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Color(0xFFBFBFBF),
                                      ),
                                      label: const Text(
                                        "Xem Trailer",
                                        style:
                                            TextStyle(color: Color(0xFFBFBFBF)),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 0,
                                          horizontal: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                            StatefulBuilder(builder: (context, setState) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: _selectedIndex == 0
                                              ? const Color(0xFF261D08)
                                              : const Color(0xFF1C1C1C),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: _selectedIndex == 0
                                                ? const Color(0xFFFCC434)
                                                : Colors.transparent,
                                            width: 2,
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Vincom Ocean Park CGV ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 22),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Da Ton, Gia Lam, Ha Noi",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                30, // Giới hạn chiều rộng của ảnh
                                            child: Image.asset(
                                              'assets/images/cgv.png',
                                              fit: BoxFit
                                                  .cover, // Đảm bảo ảnh không bị cắt
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = 1;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: _selectedIndex == 1
                                              ? const Color(0xFF261D08)
                                              : const Color(0xFF1C1C1C),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: _selectedIndex == 1
                                                ? const Color(0xFFFCC434)
                                                : Colors.transparent,
                                            width: 2,
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Lotte Cinema Long Bien ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 22),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "7-9 Nguyen Van Linh, Long Bien, Ha Noi",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width:
                                                30, // Giới hạn chiều rộng của ảnh
                                            child: Image.asset(
                                              'assets/images/lotte.png',
                                              fit: BoxFit
                                                  .cover, // Đảm bảo ảnh không bị cắt
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
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
                        fontSize: 22),
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
      // Nền mờ cho chữ
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF1C1C1C),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieDetail.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                formatRuntime(movieDetail.runtime),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const Text(" • ", style: TextStyle(color: Colors.white)),
              Text(
                formatDate(widget.movie.releaseDate),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              const Text("Review",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 16,
              ),
              const SizedBox(width: 2),
              Text(
                widget.movie.voteAverage.toStringAsFixed(1),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(width: 4),
              Text(
                '(${widget.movie.voteCount})',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
          Row(
            children: [
              StatefulBuilder(
                builder: (context, setStarState) {
                  return Row(
                    children: List.generate(5, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: SizedBox(
                          width: 32,
                          child: IconButton(
                            icon: Icon(
                              index < _selectedStars ? Icons.star : Icons.star,
                              color: index < _selectedStars
                                  ? const Color(0xFFFCC434)
                                  : const Color(0xFF575757),
                              size: 34,
                            ),
                            onPressed: () {
                              setStarState(() {
                                _selectedStars = index + 1;
                              });
                              _saveSelectedStars(index + 1);
                            },
                            padding: const EdgeInsets.all(0),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(
                width: 20,
              ),
              // Nút xem trailer
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFBFBFBF),
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Gọi API để lấy URL trailer
                    final trailerUrl =
                        await APIserver().getMovieTrailer(movieDetail.id);

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
                      // Hiển thị thông báo nếu không tìm thấy trailer
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Không tìm thấy trailer!'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Color(0xFFBFBFBF),
                  ),
                  label: const Text(
                    "Xem Trailer",
                    style: TextStyle(color: Color(0xFFBFBFBF)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Language extends StatelessWidget {
  const Language({
    super.key,
    required this.movieDetail,
  });

  final Movie movieDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Language:",
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFFCDCDCD),
              overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(
          width: 7,
        ),
        Expanded(
          child: ReadMoreText(
            movieDetail.languages.join(', '),
            style: const TextStyle(fontSize: 16),
            trimLines: 1,
            trimLength: 30,
            colorClickableText: Colors.yellow,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'See more',
            trimExpandedText: ' See less',
          ),
        ),
      ],
    );
  }
}

class Genres extends StatelessWidget {
  const Genres({
    super.key,
    required this.movieDetail,
  });

  final Movie movieDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Movie genre:",
          style: TextStyle(fontSize: 16, color: Color(0xFFCDCDCD)),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: ReadMoreText(
            movieDetail.genres.join(', '),
            style: const TextStyle(fontSize: 16),
            trimLines: 1,
            trimLength: 30,
            colorClickableText: Colors.yellow,
            trimMode: TrimMode.Line,
            trimCollapsedText: 'See more',
            trimExpandedText: ' See less',
          ),
        ),
      ],
    );
  }
}

class Censorship extends StatelessWidget {
  const Censorship({
    super.key,
    required this.movieDetail,
  });

  final Movie movieDetail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: APIserver().getMovieCertification(movieDetail.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final certification = snapshot.data;
          return Row(
            children: [
              const Text(
                "Censorship:",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFCDCDCD),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "$certification+",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}

class Credits extends StatelessWidget {
  const Credits({
    super.key,
    required this.movieDetail,
  });

  final Movie movieDetail;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: APIserver().getMovieCredits(movieDetail.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No credits available"));
          }

          final credits = snapshot.data!;
          final List<Map<String, String?>> actors = credits['actors'] ?? [];
          final List<Map<String, String?>> directors =
              credits['directors'] ?? [];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Director",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: directors.length,
                    itemBuilder: (context, index) {
                      final director = directors[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            director['profile_path'] != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      director['profile_path']!,
                                    ),
                                    radius: 15,
                                  )
                                : const CircleAvatar(
                                    radius: 15,
                                    child: Icon(Icons.person),
                                  ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 55,
                              child: Text(
                                director['name'] ?? "Unknown",
                                style: const TextStyle(fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Actor",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: actors.length,
                  itemBuilder: (context, index) {
                    final actor = actors[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          actor['profile_path'] != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(actor['profile_path']!),
                                  radius: 15,
                                )
                              : const CircleAvatar(
                                  radius: 15,
                                  child: Icon(Icons.person),
                                ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 55,
                            child: Text(
                              actor['name'] ?? "Unknown",
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        });
  }
}
