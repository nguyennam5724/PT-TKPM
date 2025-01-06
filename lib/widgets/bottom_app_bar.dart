import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({super.key});

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  Map<String, bool> isTapped = {
    'home': false,
    'theaters': false,
    'movies': false,
    'profile': false,
  };

  void onTap(String key) {
    setState(() {
      isTapped[key] = !isTapped[key]!;
    });

    Future.delayed(const Duration(milliseconds: 100), (){
      setState(() {
        isTapped[key] = false;
    });
   });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF1E1E1E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Hành động khi nhấn vào "Home"
              onTap('home');
              print('Home');
            },
            child: Column(
              
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, color: isTapped['home']! ? Colors.yellow : Colors.white),
                const Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Hành động khi nhấn vào "Theaters"
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.theaters, color: Colors.white),
                Text(
                  "Theaters",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Hành động khi nhấn vào "Video"
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FeatherIcons.video, color: Colors.white),
                Text(
                  "Video",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Hành động khi nhấn vào "Profile"
            },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FeatherIcons.user, color: Colors.white),
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
