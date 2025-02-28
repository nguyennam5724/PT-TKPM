import 'package:flutter/material.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';

class ComingSoonHeader extends StatelessWidget {
  const ComingSoonHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Coming soon",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const MainScreen(initialIndex: 2), 
                ),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: Colors.yellow),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 14)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
