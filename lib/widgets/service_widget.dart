import 'package:flutter/material.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Retal tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/Retal.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Retal",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("IMAX tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/Imax.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Imax",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("4DX tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/4Dx.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "4DX",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("SweetBox tapped!")),
            );
          },
          child: Column(
            children: [
              ClipOval(
                child: Image.asset(
                  "assets/images/Sweetbox.png",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "SweetBox",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
