import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:moviego/Model/movie.dart';
import 'package:moviego/Services/services.dart';
import 'package:moviego/screens/moviedetails.dart';

class SearchBarMovie extends StatefulWidget {
  const SearchBarMovie({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final APIserver _apiServer = APIserver();
  List<Movie> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Cập nhật trạng thái khi focus thay đổi
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      try {
        List<Movie> results = await _apiServer.searchMovies(query);
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isSearching = false;
        });
      }
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _searchResults = [];
    });
  }

  void _hideSearchResults() {
    setState(() {
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Nhận tất cả các sự kiện chạm
      onTap: () {
        FocusScope.of(context).unfocus(); // Đóng bàn phím
        _hideSearchResults(); // Ẩn kết quả tìm kiếm
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(FeatherIcons.search, color: Colors.white),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: _clearSearch,
                      )
                    : null,
                hintText: 'Search movies...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
                filled: true,
                fillColor: Colors.grey[900],
              ),
              onChanged: _onSearchChanged,
              onTap: () {
                // Không làm gì khi nhấn vào TextField
              },
            ),
          ),
          if (_searchResults.isNotEmpty)
            GestureDetector(
              onTap: () {
                // Ngăn chặn đóng danh sách khi nhấn vào trong danh sách
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                constraints: const BoxConstraints(
                  maxHeight: 300, // Giới hạn chiều cao danh sách kết quả
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8)
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: _searchResults.map((movie) {
                      return ListTile(
                        
                        leading: Image.network(
                          "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                          fit: BoxFit.cover,
                        ),
                        title: Text(movie.title,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(
                          movie.genres.join(", "),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(movie: movie),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          if (_isSearching)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}