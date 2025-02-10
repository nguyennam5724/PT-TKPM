import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:moviego/Model/movie.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
const apiKey = '27b1bcddbbc2b60c4ac18f9a69a36ecb';
var key = '?api_key=$apiKey';
late String endPoint;
late String page;

class APIserver {
  // Lấy danh sách các phim đang chiếu
  Future<List<Movie>> getNowShowing() async {
    endPoint = 'movie/now_playing';
    page = '&page=1';
    final url = '$baseUrl$endPoint$key$page';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getNowShowing: success');
      final data = jsonDecode(response.body)['results'] as List;

      // Lấy danh sách các ID thể loại từ các bộ phim
      List<List<int>> genreIdsList = data.map((movieData) {
        return List<int>.from(movieData['genre_ids']);
      }).toList();

      // Lấy tên thể loại từ ID sau khi đã nhận được danh sách ID thể loại
      List<List<String>> genresList = await _getGenresByIds(genreIdsList);

      // Lấy danh sách ngôn ngữ từ thông tin phim (kiểm tra null)
      List<List<String>> languagesList = data.map((movieData) {
        return movieData['spoken_languages'] != null
            ? List<String>.from(movieData['spoken_languages']
                .map((lang) => lang['english_name'] ?? 'Unknown'))
            : <String>[];
      }).toList();

      // Trả về danh sách các Movie đã được thêm tên thể loại và ngôn ngữ
      return data
          .asMap()
          .map((index, movieData) {
            return MapEntry(
                index,
                Movie.fromMap(
                    movieData, genresList[index], languagesList[index]));
          })
          .values
          .toList();
    }
    throw Exception('Failed to load now showing movies');
  }

  Future<List<Movie>> getComingSoon() async {
    endPoint = 'movie/upcoming';
    page = '&page=7';
    final url = '$baseUrl$endPoint$key$page';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getComingSoon: success');
      final data = jsonDecode(response.body)['results'] as List;

      // Lấy danh sách các ID thể loại từ các bộ phim
      List<List<int>> genreIdsList = data.map((movieData) {
        return List<int>.from(movieData['genre_ids']);
      }).toList();

      // Lấy tên thể loại từ ID sau khi đã nhận được danh sách ID thể loại
      List<List<String>> genresList = await _getGenresByIds(genreIdsList);

      // Lấy danh sách ngôn ngữ từ thông tin phim (kiểm tra null)
      List<List<String>> languagesList = data.map((movieData) {
        return movieData['spoken_languages'] != null
            ? List<String>.from(movieData['spoken_languages']
                .map((lang) => lang['english_name'] ?? 'Unknown'))
            : <String>[];
      }).toList();

      // Trả về danh sách các Movie đã được thêm tên thể loại và ngôn ngữ
      return data
          .asMap()
          .map((index, movieData) {
            return MapEntry(
                index,
                Movie.fromMap(
                    movieData, genresList[index], languagesList[index]));
          })
          .values
          .toList();
    }
    throw Exception('Failed to load coming soon movies');
  }

  // Lấy chi tiết phim
  Future<Movie> getMovieDetail(int id) async {
    endPoint = 'movie/$id';
    final url = '$baseUrl$endPoint$key';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getMovieDetail: success');
      final data = jsonDecode(response.body);

      // Lấy thể loại phim từ chi tiết
      List<String> genres = (data['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList();

      // Lấy ngôn ngữ nói trong phim
      List<String> languages = (data['spoken_languages'] as List)
          .map((language) => language['english_name'] as String)
          .toList();

      return Movie.fromMap(data, genres, languages);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    endPoint = 'movie/$movieId/credits';
    final url = '$baseUrl$endPoint$key';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log('getMovieCredits: success');
      final data = jsonDecode(response.body);
      final List<Map<String, String?>> actors = (data['cast'] as List)
          .where((castMember) => castMember['known_for_department'] == "Acting")
          .map((castMember) => {
                "name": castMember['name'] as String,
                "profile_path": castMember['profile_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${castMember['profile_path']}'
                    : null,
              })
          .toList();

      final List<Map<String, String?>> directors = (data['crew'] as List)
          .where((castMember) => castMember['job'] == "Director")
          .map((castMember) => {
                "name": castMember['name'] as String,
                "profile_path": castMember['profile_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${castMember['profile_path']}'
                    : null,
              })
          .toList();

      return {
        "actors": actors,
        "directors": directors,
      };
    } else {
      throw Exception('Failed to load movie credits');
    }
  }

// Lấy thông tin chứng chỉ của một bộ phim
  Future<String?> getMovieCertification(int movieId) async {
    endPoint = 'movie/$movieId/release_dates';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getMovieCertification: success');
      final data = jsonDecode(response.body)['results'] as List;

      // Tìm thông tin liên quan đến US và type = 3
      for (var entry in data) {
        if (entry['iso_3166_1'] == 'DE') {
          List releaseDates = entry['release_dates'];
          for (var release in releaseDates) {
            if (release['type'] == 3) {
              return release['certification'];
            } else if (release['type'] == 4) {
              return release['certification'];
            }
          }
        } else if (entry['iso_3166_1'] == 'US') {
          List releaseDates = entry['release_dates'];
          for (var release in releaseDates) {
            if (release['type'] == 3) {
              return release['certification'];
            } else if (release['type'] == 4) {
              return release['certification'];
            }
          }
        } else if (entry['iso_3166_1'] == 'IL') {
          List releaseDates = entry['release_dates'];
          for (var release in releaseDates) {
            if (release['type'] == 3) {
              return release['certification'];
            } else if (release['type'] == 4) {
              return release['certification'];
            }
          }
        }
      }
      // Nếu không tìm thấy chứng chỉ
      return null;
    } else {
      throw Exception('Failed to load movie certification');
    }
  }

  Future<String?> getMovieTrailer(int movieId) async {
    endPoint = 'movie/$movieId/videos';
    final url = '$baseUrl$endPoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      log('getMovieTrailer: success');
      final data = jsonDecode(response.body)['results'] as List;

      // Lọc các video có type là "Trailer"
      for (var video in data) {
        if (video['type'] == 'Trailer' && video['site'] == 'YouTube') {
          // Trả về URL của trailer trên YouTube
          return 'https://www.youtube.com/watch?v=${video['key']}';
        }
      }

      // Nếu không tìm thấy trailer
      return null;
    } else {
      throw Exception('Failed to load movie trailer');
    }
  }

  // Lấy tên thể loại từ ID
  Future<List<List<String>>> _getGenresByIds(
      List<List<int>> genreIdsList) async {
    const genreEndpoint = 'genre/movie/list';
    final url = '$baseUrl$genreEndpoint$key';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Danh sách các thể loại với ID và tên
      List<Map<String, dynamic>> allGenres =
          List<Map<String, dynamic>>.from(data['genres']);

      // Tạo một map để ánh xạ từ ID thể loại sang tên thể loại
      Map<int, String> genreMap = {};
      for (var genre in allGenres) {
        genreMap[genre['id']] = genre['name'];
      }

      // // In toàn bộ danh sách thể loại để kiểm tra
      // log('All Genres: $genreMap');

      // Lấy tên thể loại cho mỗi bộ phim từ các ID
      List<List<String>> genresList = [];
      for (var genreIds in genreIdsList) {
        List<String> genres = [];
        for (int genreId in genreIds) {
          // Kiểm tra nếu genreId có trong genreMap và lấy tên thể loại
          if (genreMap.containsKey(genreId)) {
            genres.add(genreMap[genreId]!);
          } else {
            // Nếu không có thể loại hợp lệ, thêm "Unknown"
            genres.add('Unknown');
          }
        }
        // Nếu danh sách thể loại rỗng, có thể thay bằng "No Genre"
        if (genres.isEmpty) {
          genres.add('No Genre');
        }
        genresList.add(genres);
      }


      return genresList;
    }
    throw Exception('Failed to load genres');
  }

  Future<List<Movie>> searchMovies(String query) async {
    // Lấy danh sách các phim đang chiếu và sắp chiếu
    List<Movie> nowPlayingMovies = await getNowShowing();
    List<Movie> comingSoonMovies = await getComingSoon();

    // Kết hợp hai danh sách phim
    List<Movie> allMovies = nowPlayingMovies + comingSoonMovies;

    String normalizedQuery = query.toLowerCase();

  // Tách từ khóa
  List<String> keywords = normalizedQuery.split(' ');

  // Tìm kiếm các tiêu đề phim khớp với từ khóa
  List<Movie> searchResults = allMovies.where((movie) {
    String normalizedTitle = movie.title.toLowerCase();
    return keywords.every((keyword) => normalizedTitle.contains(keyword));
  }).toList();

  // Sắp xếp kết quả:
  searchResults.sort((a, b) {
    String normalizedA = a.title.toLowerCase();
    String normalizedB = b.title.toLowerCase();

    // Ưu tiên khớp chính xác
    if (normalizedA == normalizedQuery && normalizedB != normalizedQuery) {
      return -1;
    } else if (normalizedA != normalizedQuery && normalizedB == normalizedQuery) {
      return 1;
    }

    // Ưu tiên tiêu đề bắt đầu bằng từ khóa
    if (normalizedA.startsWith(normalizedQuery) && !normalizedB.startsWith(normalizedQuery)) {
      return -1;
    } else if (!normalizedA.startsWith(normalizedQuery) && normalizedB.startsWith(normalizedQuery)) {
      return 1;
    }

    // Mặc định sắp xếp theo tên
    return a.title.compareTo(b.title);
  });

  return searchResults;
  }
}
