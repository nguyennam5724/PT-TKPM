import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/homepage.dart';
import 'package:moviego/screens/moviedetails.dart';

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
                      Center(
  child: Row(
    mainAxisSize: MainAxisSize.min, // Giới hạn kích thước theo nội dung
    mainAxisAlignment: MainAxisAlignment.center, // Căn giữa ngang
    crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa dọc
    children: [
      const Icon(
        Icons.access_time,
        color: Colors.white,
        size: 12,
      ),
      const SizedBox(width: 1),
      Text(
        formatRuntime(movieDetail.runtime),
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      const SizedBox(width: 3),
      const Text(
        "•",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      const SizedBox(width: 3),
      Flexible( // Thay Expanded bằng Flexible để không ép toàn bộ không gian
        child: Text(
          movie.genres.join(', '),
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis, 
          textAlign: TextAlign.center, // Căn giữa nội dung chữ
        ),
      ),
    ],
  ),
),

                  
                      // Đánh giá phim
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.yellow,size: 17,),
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
            aspectRatio: 0.66,
            scrollPhysics: const BouncingScrollPhysics(),
            enableInfiniteScroll: true,
          ),
        );
      },
    );
  }
}
