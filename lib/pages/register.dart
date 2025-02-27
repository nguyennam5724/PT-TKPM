import 'package:flutter/material.dart';
import 'package:moviego/auth/auth_service.dart';
import 'package:moviego/pages/sign_in_password.dart';
import 'package:moviego/pages/snack_bar.dart';
import 'package:moviego/widgets/bottom_app_bar.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Color _facebookButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _googleButtonColor = const Color.fromARGB(197, 55, 38, 38);
  Color _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);

  bool _isObscured = true;
  bool _isPressed = false;
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
  }

  void signUpUsers() async {
    String res = await AuthService().signUpUser(
      email: _emailController.text,
      userName: _userNameController.text,
      password: _passwordController.text,
    );
    if (res == "Successfully") {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ));
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background(),
          _content(context),
        ],
      ),
    );
  }

  Positioned _background() {
    return Positioned.fill(
      child: Stack(
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Color.fromARGB(220, 0, 0, 0),
                  Color.fromARGB(160, 0, 0, 0),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Positioned _content(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: MediaQuery.of(context).size.width * 0.05,
      right: MediaQuery.of(context).size.width * 0.05,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/mg.png',
            width: 250,
            height: 250,
          ),
          const SizedBox(height: 50),
          const Text(
            "Create Your Account",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Kanit',
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color.fromARGB(150, 152, 157, 149),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(197, 55, 38, 38),
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(100, 152, 157, 149),
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                controller: _emailController,
              ),
              const SizedBox(height: 12),
              TextFormField(
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromARGB(150, 152, 157, 149),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(197, 55, 38, 38),
                  contentPadding: EdgeInsets.all(16),
                  hintText: 'User Name',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(100, 152, 157, 149),
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                controller: _userNameController,
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: _isObscured,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color.fromARGB(150, 152, 157, 149),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.remove_red_eye : Icons.visibility_off,
                      color: const Color.fromARGB(150, 152, 157, 149),
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(197, 55, 38, 38),
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(100, 152, 157, 149),
                    fontSize: 18,
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                controller: _passwordController,
              ),
            ],
          ),
          const SizedBox(height: 24),
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
              signUpUsers();
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
                    const Color(0xFFF6B027).withOpacity(_isPressed ? 0.9 : 1.0),
                    const Color(0xFFB27600).withOpacity(_isPressed ? 0.9 : 1.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Continue",
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
          SizedBox(
            width: double.infinity,
            height: 50,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "- - - - - - - - - - - - - -     ",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                      fontFamily: 'FontStyle',
                    ),
                  ),
                  const TextSpan(
                    text: "or continue with",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  print("Sign In with Facebook");
                },
                onTapDown: (_) {
                  setState(() {
                    _facebookButtonColor =
                    const Color.fromARGB(111, 174, 146, 146);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _facebookButtonColor =
                    const Color.fromARGB(197, 55, 38, 38);
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _facebookButtonColor =
                    const Color.fromARGB(197, 55, 38, 38);
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: _facebookButtonColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(
                      'assets/icon/Facebook-logo.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    )),
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  print("Sign In with Google");
                },
                onTapDown: (_) {
                  setState(() {
                    _googleButtonColor =
                    const Color.fromARGB(111, 174, 146, 146);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _googleButtonColor = const Color.fromARGB(197, 55, 38, 38);
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _googleButtonColor = const Color.fromARGB(197, 55, 38, 38);
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: _googleButtonColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(
                      'assets/icon/Google-logo.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    )),
              ),
              const SizedBox(
                width: 12,
              ),
              GestureDetector(
                onTap: () {
                  print("Sign In with Apple");
                },
                onTapDown: (_) {
                  setState(() {
                    _appleButtonColor =
                    const Color.fromARGB(111, 174, 146, 146);
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _appleButtonColor = const Color.fromARGB(197, 55, 38, 38);
                  });
                },
                child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: _appleButtonColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Image.asset(
                      'assets/icon/Apple-logo.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    )),
              ),
            ],
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
                const TextSpan(text: "You have an account? "),
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
                              builder: (context) => const SignInPass()),
                        );
                      },
                      child: const Text(
                        'Sign-in',
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
    );
  }
}