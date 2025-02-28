import 'package:flutter/material.dart';
import 'package:moviego/Model/movie.dart';
import 'package:readmore/readmore.dart';

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
