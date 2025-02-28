import 'package:flutter/material.dart';
import 'package:moviego/Model/movie.dart';
import 'package:readmore/readmore.dart';

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
