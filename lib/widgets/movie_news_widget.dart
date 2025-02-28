import 'package:flutter/material.dart';

class MovieNewsWidget extends StatelessWidget {
  const MovieNewsWidget({
    super.key,
    required this.movieNews,
  });

  final List<Map<String, String>> movieNews;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(movieNews.length, (index) {
            final movie = movieNews[index];
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${movie['title']} tapped!")),
                );
              },
              child: Container(
                width: 200,
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        movie['image']!,
                        height: 150, // Đặt chiều cao cố định
                        width: double.infinity, // Đặt chiều rộng vừa khung
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      movie['title']!,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
