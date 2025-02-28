import 'package:flutter/material.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';

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
