import 'package:flutter/material.dart';

class DottedLineWithHalfCircles extends StatelessWidget {
  const DottedLineWithHalfCircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(300, 20),
        painter: DottedLinePainter(),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final double radius = size.height / 2;

    // Vẽ nửa hình tròn bên trái
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      -3.14 / 2,
      3.14,
      false,
      paint,
    );

    // Vẽ nửa hình tròn bên phải
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - radius, radius), radius: radius),
      3.14 / 2,
      3.14,
      false,
      paint,
    );

    // Vẽ đường nét đứt ở giữa
    final double dashWidth = 10;
    final double dashSpace = 5;
    double startX = radius * 2;
    final double endX = size.width - radius * 2;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, radius),
        Offset(startX + dashWidth, radius),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}