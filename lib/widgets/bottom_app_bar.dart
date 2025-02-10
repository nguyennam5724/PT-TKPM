import 'package:flutter/material.dart';
import 'package:moviego/screens/homepage.dart';
import 'package:moviego/screens/movie.dart';
import 'package:moviego/screens/profile.dart';
import 'package:moviego/screens/ticket.dart';


class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      HomePage(onTabChange: _onTabChange),
      const TicketPage(),
      MoviePage(selectedCategory: 'Now Playing'),
      const ProfilePage(),
    ];
  }

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void navigateToMovies(String category) {
    setState(() {
      _currentIndex = 2; 
    });

    // Thay đổi danh mục trong MoviePage
    final moviePage = _pages[2] as MoviePage;
    moviePage.changeCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(top: 2),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF262626), width: 1.5)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: _currentIndex,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.yellow,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.theaters),
              label: 'Ticket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.video_library),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
