import 'package:flutter/material.dart';

class DialogHelper {
  static void showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}