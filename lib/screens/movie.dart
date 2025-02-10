import 'package:flutter/material.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/moviedetails.dart';


class MoviePage extends StatefulWidget {
  final String selectedCategory;

  const MoviePage({super.key, required this.selectedCategory});

  @override
  _MoviePageState createState() => _MoviePageState();

  void changeCategory(String category) {
    _MoviePageState? state = _MoviePageState();
    state.changeCategory(category);
  }
}

class _MoviePageState extends State<MoviePage> {
  final List<String> categories = ['Now Playing', 'Coming Soon'];
  late int selectedIndex;
  late final Future<List<Movie>> _nowPlayingMovies =
      APIserver().getNowShowing();
  late final Future<List<Movie>> _comingSoonMovies =
      APIserver().getComingSoon();
  @override
  void initState() {
    super.initState();
    // Dựa vào selectedCategory để xác định index của danh mục
    selectedIndex = categories.indexOf(widget.selectedCategory);
  }

  void changeCategory(String category) {
    setState(() {
      selectedIndex = categories.indexOf(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 16, right: 8, left: 8, bottom: 8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(categories.length, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? const Color(0xFFFCC434)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: selectedIndex == index
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Nội dung tương ứng với mục đã chọn
            Expanded(
              child: FutureBuilder<List<Movie>>(
                future:
                    selectedIndex == 0 ? _nowPlayingMovies : _comingSoonMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No movies available.'));
                  } else {
                    final movies = snapshot.data!;
                    return ListView.builder(
                      itemCount: (movies.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        final movie1 = movies[index * 2];
                        final movie2 = index * 2 + 1 < movies.length
                            ? movies[index * 2 + 1]
                            : null;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FutureBuilder<Movie>(
                                future: APIserver().getMovieDetail(
                                    movie1.id), // Gọi chi tiết bộ phim 1
                                builder: (context, movieDetailSnapshot) {
                                  if (movieDetailSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (movieDetailSnapshot.hasError) {
                                    return Center(
                                        child: Text(
                                            "Error: ${movieDetailSnapshot.error}"));
                                  } else if (!movieDetailSnapshot.hasData) {
                                    return const Center(
                                        child:
                                            Text("No movie details available"));
                                  } else {
                                    final movieDetail =
                                        movieDetailSnapshot.data!;
                                    return GestureDetector(
                                      onTap: () {
                                        // Điều hướng tới trang chi tiết của phim
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailPage(
                                                    movie: movieDetail),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 270,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    "https://image.tmdb.org/t/p/original${movie1.posterPath}",
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(movie1.title,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Color(0xFFFCC434),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  movie1.voteAverage
                                                      .toStringAsFixed(1),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  width: 1,
                                                ),
                                                Text('(${movie1.voteCount})',
                                                    style: const TextStyle(
                                                        fontSize: 10)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  formatRuntime(
                                                      movieDetail.runtime),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.videocam,
                                                    size: 12),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      movie1.genres.join(', '),
                                                      style: const TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 12,
                                                          overflow: TextOverflow
                                                              .ellipsis)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            // Bộ phim 2 (nếu có)
                            if (movie2 != null)
                              Expanded(
                                  child: FutureBuilder<Movie>(
                                      future: APIserver().getMovieDetail(
                                          movie2.id), // Gọi chi tiết bộ phim 1
                                      builder: (context, movieDetailSnapshot) {
                                        if (movieDetailSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (movieDetailSnapshot
                                            .hasError) {
                                          return Center(
                                              child: Text(
                                                  "Error: ${movieDetailSnapshot.error}"));
                                        } else if (!movieDetailSnapshot
                                            .hasData) {
                                          return const Center(
                                              child: Text(
                                                  "No movie details available"));
                                        } else {
                                          final movieDetail =
                                              movieDetailSnapshot.data!;
                                          return GestureDetector(
                                            onTap: () {
                                              // Điều hướng tới trang chi tiết của phim
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieDetailPage(
                                                          movie: movieDetail),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 270,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          "https://image.tmdb.org/t/p/original${movie2.posterPath}",
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(movie2.title,
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFFFCC434),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 12,
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        movie2.voteAverage
                                                            .toStringAsFixed(1),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(
                                                          '(${movie2.voteCount})',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      10)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.access_time,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text(
                                                        formatRuntime(
                                                            movieDetail
                                                                .runtime),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.videocam,
                                                          size: 12),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            movie2.genres
                                                                .join(', '),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 12,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      })),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavBar(),
      backgroundColor: Colors.black,
    );
  }

  String formatRuntime(int runtime) {
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    return '$hours hour $minutes minutes';
  }
}
