import 'package:flutter/material.dart';
import 'package:moviego/pages/register.dart';
import 'package:moviego/pages/sign_in_btn.dart';
import 'package:moviego/pages/sign_in_password.dart';

class SignInAPI extends StatefulWidget {
  const SignInAPI({super.key});

  @override
  State<SignInAPI> createState() => _SignInAPIState();
}

class _SignInAPIState extends State<SignInAPI> {
  Color _facebookButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _facebookTextColor = Colors.white;

  Color _googleButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _googleTextColor = Colors.white;

  Color _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _appleTextColor = Colors.white;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          Image.asset(
            'assets/images/BG.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/Movie-imgs.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Color.fromARGB(220, 0, 0, 0),
                  Color.fromARGB(160, 0, 0, 0),
                ],
                stops: [
                  0.0,
                  0.55,
                  1.0,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.05,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/mg.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kanit',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SignInButton(
                    text: "Continue with Facebook",
                    iconPath: 'assets/icon/Facebook-logo.png',
                    buttonColor: _facebookButtonColor,
                    textColor: _facebookTextColor,
                    onTap: () {
                      print("Sign In with Facebook");
                    },
                    onTapDown: () {
                      setState(() {
                        _facebookButtonColor =
                            const Color.fromARGB(111, 174, 146, 146);
                        _facebookTextColor = Colors.black;
                      });
                    },
                    onTapUp: () {
                      setState(() {
                        _facebookButtonColor =
                            const Color.fromARGB(197, 55, 38, 38);
                        _facebookTextColor = Colors.white;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _facebookButtonColor =
                            const Color.fromARGB(197, 55, 38, 38);
                        _facebookTextColor = Colors.white;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SignInButton(
                    text: "Continue with Google",
                    iconPath: 'assets/icon/Google-logo.png',
                    buttonColor: _googleButtonColor,
                    textColor: _googleTextColor,
                    onTap: () {
                      print("Sign In with Google");
                    },
                    onTapDown: () {
                      setState(() {
                        _googleButtonColor =
                            const Color.fromARGB(111, 174, 146, 146);
                        _googleTextColor = Colors.black;
                      });
                    },
                    onTapUp: () {
                      setState(() {
                        _googleButtonColor =
                            const Color.fromARGB(197, 55, 38, 38);
                        _googleTextColor = Colors.white;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _googleButtonColor =
                            const Color.fromARGB(197, 55, 38, 38);
                        _googleTextColor = Colors.white;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SignInButton(
                    text: "Continue with Apple",
                    iconPath: 'assets/icon/Apple-logo.png',
                    buttonColor: _appleButtonColor,
                    textColor: _appleTextColor,
                    onTap: () {
                      print("Sign In with Apple");
                    },
                    onTapDown: () {
                      setState(() {
                        _appleButtonColor =
                            const Color.fromARGB(111, 174, 146, 146);
                        _appleTextColor = Colors.black;
                      });
                    },
                    onTapUp: () {
                      setState(() {
                        _appleButtonColor =
                            const Color.fromARGB(197, 55, 38, 38);
                        _appleTextColor = Colors.white;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        _appleButtonColor =
                            const Color.fromARGB(197, 55, 38, 38);
                        _appleTextColor = Colors.white;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "- - - - - - - - - - - - - - - - - - - -     ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              fontFamily: 'FontStyle',
                            ),
                          ),
                          const TextSpan(
                            text: "or",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                "     - - - - - - - - - - - - - - - - - - - - - - - - - ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              fontFamily: 'FontStyle',
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isPressed = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPass()),
                      );
                    },
                    onTapCancel: () {
                      setState(() {
                        _isPressed = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            const Color(0xFFF6B027)
                                .withOpacity(_isPressed ? 0.9 : 1.0),
                            const Color(0xFFB27600)
                                .withOpacity(_isPressed ? 0.9 : 1.0),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Log in with password",
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
                  const SizedBox(
                    height: 24,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontFamily: 'Open_Sans_2',
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        WidgetSpan(
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFF6B027),
                                Color(0xFFB27600),
                              ],
                            ).createShader(bounds),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()),
                                );
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    fontFamily: 'Open_Sans_2',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    decorationThickness: 2.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
