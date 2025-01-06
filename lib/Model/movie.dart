class Movie {
  final String title;
  final String backDropPath;
  final String posterPath;
  final double voteAverage;
  final int voteCount;
  final int id;
  final String releaseDate;
  final int runtime;
  final List<String> genres;

  Movie({
    required this.title,
    required this.backDropPath,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.id,
    required this.releaseDate,
    required this.runtime,
    required this.genres,
  });

  factory Movie.fromMap(Map<String, dynamic> map, List<String> genres) {
    return Movie(
       id: map['id'] ?? 0,
    title: map['title'] ?? 'Unknown Title',
    backDropPath: map['backdrop_path'] ?? '', 
    posterPath: map['poster_path'] ?? '', 
    voteAverage: (map['vote_average'] ?? 0).toDouble(), 
    voteCount: map['vote_count'] ?? 0, 
    releaseDate: map['release_date'] ?? '',
    runtime: map['runtime'] ?? 0,
    genres: genres ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'backDropPath': backDropPath,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'id': id,
      'releaseDate': releaseDate,
      'runtime': runtime,
      'genres': genres
    };
  }
}
