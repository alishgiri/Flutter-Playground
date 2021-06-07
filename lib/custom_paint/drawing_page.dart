import 'package:flutter/material.dart';
import 'package:test_in_flutter/custom_paint/curve_painter.dart';

class DrawingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blade Runner"),
      ),
      body: CustomPaint(
        painter: CurvePainter(),
        child: Center(
          child: Text("Blade Runner"),
        ),
      ),
    );
  }
}
