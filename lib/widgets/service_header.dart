import 'package:flutter/material.dart';

class ServiceHeader extends StatelessWidget {
  const ServiceHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Service",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              // code to navigate to another screen
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
