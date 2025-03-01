import 'package:flutter/material.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/controllers/movie_detail_controller.dart'; // Import Controller
import 'package:moviego/screens/select_seat.dart';
import 'package:moviego/widgets/censorship.dart';
import 'package:moviego/widgets/credits.dart';
import 'package:moviego/widgets/dialog_helper.dart';
import 'package:moviego/widgets/genres.dart';
import 'package:moviego/widgets/language.dart';
import 'package:readmore/readmore.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late MovieDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MovieDetailController(movie: widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: _controller.getMovieDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No details available", style: TextStyle(color: Colors.white)));
          }

          final movieDetail = snapshot.data!;
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return Stack(
            children: [
              Image.network(
                "https://image.tmdb.org/t/p/original${movieDetail.backDropPath}",
                height: screenHeight * 0.35,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: screenHeight * 0.35,
                  width: double.infinity,
                  color: Colors.grey,
                  child: const Center(child: Text("No Image Available", style: TextStyle(color: Colors.amber, fontSize: 18))),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.25, left: screenWidth * 0.04, right: screenWidth * 0.04),
                  child: Column(
                    children: [
                      buildInfor1(movieDetail),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          Genres(movieDetail: movieDetail),
                          SizedBox(height: screenHeight * 0.01),
                          Censorship(movieDetail: movieDetail),
                          SizedBox(height: screenHeight * 0.01),
                          Language(movieDetail: movieDetail),
                          SizedBox(height: screenHeight * 0.02),
                          const Text("Storyline", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: screenHeight * 0.015),
                          ReadMoreText(
                            movieDetail.overview,
                            style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                            trimLines: 4,
                            trimLength: 150,
                            colorClickableText: Colors.yellow,
                            trimMode: TrimMode.Length,
                            trimCollapsedText: 'See more',
                            trimExpandedText: ' See less',
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Credits(movieDetail: movieDetail),
                          SizedBox(height: screenHeight * 0.02),
                          const Text("Cinema", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(height: screenHeight * 0.015),
                          buildCinema(),
                          SizedBox(height: screenHeight * 0.02),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCC434),
                              borderRadius: BorderRadius.circular(screenWidth * 0.03),
                            ),
                            child: TextButton(
                              onPressed: () {
                                if (_controller.selectedIndex == -1) {
                                  DialogHelper.showCustomDialog(context, "Thông báo", "Vui lòng chọn rạp chiếu phim trước khi tiếp tục!");
                                } else {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => SelectSeat(
                                        movieTitle: movieDetail.title,
                                        movieRuntime: movieDetail.runtime,
                                        cinemaName: _controller.cinemaList[_controller.selectedIndex]["name"]!,
                                        cinemaAddress: _controller.cinemaList[_controller.selectedIndex]["address"]!,
                                        cinemaImage: _controller.cinemaList[_controller.selectedIndex]["image"]!,
                                        moviePoster: movieDetail.posterPath,
                                        genres: movieDetail.genres,
                                      ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget buildCinema() {
    final screenWidth = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: List.generate(_controller.cinemaList.length, (index) {
          return GestureDetector(
            onTap: () => _controller.selectCinema(index, setState),
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              margin: EdgeInsets.only(top: screenWidth * 0.02),
              decoration: BoxDecoration(
                color: _controller.selectedIndex == index ? const Color(0xFF261D08) : const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                border: Border.all(
                  color: _controller.selectedIndex == index ? const Color(0xFFFCC434) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _controller.cinemaList[index]["name"]!,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: screenWidth * 0.045),
                        ),
                        SizedBox(height: screenWidth * 0.015),
                        Text(
                          _controller.cinemaList[index]["address"]!,
                          style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.035),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.08,
                    child: Image.asset(
                      _controller.cinemaList[index]["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Container buildInfor1(Movie movieDetail) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        color: const Color(0xFF1C1C1C).withOpacity(0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movieDetail.title,
            style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: screenWidth * 0.02),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: screenWidth * 0.01),
              Text(
                _controller.formatRuntime(movieDetail.runtime),
                style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
              ),
              SizedBox(width: screenWidth * 0.03),
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: screenWidth * 0.01),
              Text(
                _controller.formatDate(movieDetail.releaseDate),
                style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("Review", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(width: screenWidth * 0.02),
                  const Icon(Icons.star, color: Colors.yellow, size: 18),
                  SizedBox(width: screenWidth * 0.01),
                  Text(
                    movieDetail.voteAverage.toStringAsFixed(1),
                    style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  Text(
                    '(${movieDetail.voteCount})',
                    style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
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
                          onTap: () => _controller.saveSelectedStars(index + 1, setStarState),
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.01),
                            child: Icon(
                              Icons.star,
                              color: index < _controller.selectedStars ? const Color(0xFFFCC434) : const Color(0xFF575757),
                              size: screenWidth * 0.07,
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
                  final trailerUrl = await _controller.getTrailerUrl();
                  if (trailerUrl != null) {
                    final embedUrl = _controller.convertToEmbedUrl(trailerUrl);
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
                                onPressed: () => Navigator.pop(context),
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
                      const SnackBar(content: Text('Không tìm thấy trailer!')),
                    );
                  }
                },
                icon: const Icon(Icons.play_circle_filled, color: Colors.white, size: 20),
                label: const Text("Trailer", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCC434),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
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