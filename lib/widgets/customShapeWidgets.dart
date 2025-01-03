import 'package:flutter/material.dart';

class CustomShapeWidget extends StatelessWidget {
  const CustomShapeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200), // Define the size of your canvas
      painter: MyCustomPainter(),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a Paint object to define styling
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    // Draw shapes on the canvas
    // Example: Drawing a rectangle
    canvas.drawRect(
      Rect.fromLTWH(50, 50, 100, 100),
      paint,
    );

    // Example: Drawing a circle
    canvas.drawCircle(
      Offset(100, 100), // center point
      50, // radius
      paint,
    );

    // Example: Drawing a line
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      paint..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Return true if you need to repaint
  }
}
