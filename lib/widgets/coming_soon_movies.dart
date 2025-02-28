import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/homepage.dart';
import 'package:moviego/screens/moviedetails.dart';

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
