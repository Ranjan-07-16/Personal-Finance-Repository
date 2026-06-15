import 'package:flutter/material.dart';

class SimplePieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double total;

  const SimplePieChart({super.key, required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomPaint(
          painter: PieChartPainter(data: data, total: total),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double total;

  PieChartPainter({required this.data, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    double startAngle = -90.0;

    if (total == 0) {
      final paint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    for (var item in data) {
      final amount = item['amount'] as double;
      final color = item['color'] as Color;
      final sweepAngle = (amount / total) * 360.0;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        _degreesToRadians(startAngle),
        _degreesToRadians(sweepAngle),
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180.0);
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
