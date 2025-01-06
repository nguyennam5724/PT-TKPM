import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:movie_app/Model/movie.dart';

const baseUrl = 'https://api.themoviedb.org/3/';
const apiKey = '27b1bcddbbc2b60c4ac18f9a69a36ecb';
var key = '?api_key=$apiKey';
late String endPoint;

class APIserver {
  // Lấy danh sách các phim đang chiếu
  Future<List<Movie>> getNowShowing() async {
    endPoint = 'movie/now_playing';
    final url = '$baseUrl$endPoint$key';

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

      // Trả về danh sách các Movie đã được thêm tên thể loại
      return data.asMap().map((index, movieData) {
        return MapEntry(index, Movie.fromMap(movieData, genresList[index]));
      }).values.toList();
    }
    throw Exception('Failed to load now showing movies');
  }

  // Lấy danh sách các phim sắp chiếu
  Future<List<Movie>> getComingSoon() async {
    endPoint = 'movie/upcoming';
    final url = '$baseUrl$endPoint$key';

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

      // Trả về danh sách các Movie đã được thêm tên thể loại
      return data.asMap().map((index, movieData) {
        return MapEntry(index, Movie.fromMap(movieData, genresList[index]));
      }).values.toList();
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

      // Trả về đối tượng Movie với danh sách thể loại
      return Movie.fromMap(data, genres);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }

  // Lấy tên thể loại từ ID
  Future<List<List<String>>> _getGenresByIds(List<List<int>> genreIdsList) async {
  const genreEndpoint = 'genre/movie/list';
  final url = '$baseUrl$genreEndpoint$key';

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    // Danh sách các thể loại với ID và tên
    List<Map<String, dynamic>> allGenres = List<Map<String, dynamic>>.from(data['genres']);
    
    // Tạo một map để ánh xạ từ ID thể loại sang tên thể loại
    Map<int, String> genreMap = {};
    for (var genre in allGenres) {
      genreMap[genre['id']] = genre['name'];
    }

    // In toàn bộ danh sách thể loại để kiểm tra
    log('All Genres: $genreMap');

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

    // In danh sách thể loại cho từng bộ phim
    log('Genres List by IDs: $genresList');

    return genresList;
  }
  throw Exception('Failed to load genres');
}


}
