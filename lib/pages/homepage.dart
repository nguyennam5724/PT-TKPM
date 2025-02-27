import 'package:flutter/material.dart';
import 'package:moviego/auth/auth_service.dart';
import 'package:moviego/pages/sign_in_API.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isPressed = false;

  void signUpUsers() {
    print("Sign Up button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Congratulation\nYou have Successfully Signed in",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressed = true;
                });
              },
              onTapUp: (_) async {
                setState(() {
                  isPressed = false;
                });
                await AuthService().signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignInAPI()));
              },
              onTapCancel: () {
                setState(() {
                  isPressed = false;
                });
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFFF6B027)
                          .withOpacity(isPressed ? 0.9 : 1.0),
                      const Color(0xFFB27600)
                          .withOpacity(isPressed ? 0.9 : 1.0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}