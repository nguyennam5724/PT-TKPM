import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final void Function() onTapDown;
  final void Function() onTapUp;
  final void Function() onTapCancel;

  const SignInButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
    required this.buttonColor,
    required this.textColor,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapCancel,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(16),
        ),
        width: MediaQuery.of(context).size.width * 1,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                iconPath,
                width: 25,
                height: 25,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                    color: textColor, fontSize: 16, fontFamily: 'Open_Sans_1'),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}