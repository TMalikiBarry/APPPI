import 'package:flutter/material.dart';

import '../../core/theme.dart';

class LinearProgressBarPainter extends CustomPainter {

  LinearProgressBarPainter({required this.progress,
  this.color, this.background,required this.strokeWidth});
  final double progress;
  final Color? color;
  final Color? background;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Dessiner la barre de fond
    final backgroundPaint = Paint()
      ..color = background ?? Colors.grey
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      backgroundPaint,
    );

    // Dessiner la barre de progression
    final progressPaint = Paint()
      ..color = color ?? Themer.primaryStroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width * progress, size.height / 2),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomLinearProgressBar extends StatelessWidget {

  const CustomLinearProgressBar({
    super.key, 
    required this.progressValue,
    this.height = 20,
    this.progressColor,
    this.backgroundColor,
    this.width,
    this.strokeWidth = 8.0,
  });

  final double progressValue;
  final Color? progressColor;
  final Color? backgroundColor;
  final double? width;
  final double height;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      child: CustomPaint(
        painter: LinearProgressBarPainter(
          progress: progressValue,
          color: progressColor,
          background : backgroundColor,
          strokeWidth: strokeWidth
        ),
      ),
    );
  }
}


class CircularProgressBarPainter extends CustomPainter {
  
  CircularProgressBarPainter({
    required this.progress,
    this.color, 
    this.background,
    required this.strokeWidth
    });

  final double progress;
  final double strokeWidth;
  final Color? color;
  final Color? background;

  @override
  void paint(Canvas canvas, Size size) {
    // angle = 2 * pi * R
    double angle = 2 * 3.141592653589793 * progress;

    // Dessiner le cercle de fond
    final backgroundPaint = Paint()
      ..color = background ?? Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero),size.width / 2, backgroundPaint);

    // Dessiner le cercle de progression
    final progressPaint = Paint()
      ..color = color ?? Themer.primary
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2),
      -3.141592653589793 / 2,
      angle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CustomCircularProgressBar extends StatelessWidget {

  const CustomCircularProgressBar({
    super.key, 
    this.child,
    required this.progressValue,
    this.progressColor, 
    this.backgroundColor,
    this.size = 80,
    this.strokeWidth = 7.5
    });

  final double progressValue;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? child;
  final double size;
  final double strokeWidth;
  

  @override
  Widget build(BuildContext context) {
    return child != null ? Stack(
      alignment: Alignment.center,
      children: [
        _pain(),
        child!
      ],
    ): _pain();
  }


  CustomPaint _pain() => CustomPaint(
    size: Size(size, size), // Taille du cercle
    painter: CircularProgressBarPainter(
      progress: progressValue,
      color: progressColor,
      background: backgroundColor,
      strokeWidth: strokeWidth),
  );
}

