import 'package:flutter/material.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';

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
          return const Row(
            children: [
              Text(
                "Censorship:",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFCDCDCD),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "No certification ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
