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
  final String overview;
  final List<String> languages;
  final String certification;
  final String director;
  final String actor;

  Movie(
      {required this.title,
        required this.backDropPath,
        required this.posterPath,
        required this.voteAverage,
        required this.voteCount,
        required this.id,
        required this.releaseDate,
        required this.runtime,
        required this.genres,
        required this.overview,
        required this.languages,
        required this.certification,
        required this.director,
        required this.actor});

  factory Movie.fromMap(
      Map<String, dynamic> map, List<String> genres, List<String> languages) {
    return Movie(
      id: map['id'] ?? 0,
      title: map['title'] ?? 'Unknown Title',
      backDropPath: map['backdrop_path'] ?? '',
      posterPath: map['poster_path'] ?? '',
      voteAverage: (map['vote_average'] ?? 0).toDouble(),
      voteCount: map['vote_count'] ?? 0,
      releaseDate: map['release_date'] ?? '',
      runtime: map['runtime'] ?? 0,
      genres: genres,
      overview: map['overview'] ?? 'Unknown',
      languages: languages,
      certification: map['certification'] ?? '',
      director: map['director'] ?? '',
      actor: map['actor'] ?? '',
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      backDropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      genres: [],
      overview: json['overview'],
      languages: [],
      certification: json['certification'],
      director: json['director'],
      actor: json['actor'],
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
      'genres': genres,
      'overview': overview,
      'languages': languages,
      'certification': certification,
      'director': director,
      'actor': actor,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'backdrop_path': backDropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'runtime': runtime,
      'genres': genres,
      'overview': overview,
      'languages': languages,
      'certification': certification,
      'director': director,
      'actor': actor,
    };
  }
}