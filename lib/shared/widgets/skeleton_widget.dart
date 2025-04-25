import 'package:flutter/material.dart';

import '../../core/theme.dart';

class SkeletonWidget extends StatefulWidget {
  ///
  const SkeletonWidget({
    super.key,
    this.height = 15,
    this.width = 200,
    this.radius,
  });

  ///
  @override
  SkeletonWidgetState createState() => SkeletonWidgetState();

  /// hauteur du rectangle
  final double? height;

  /// largeur du rectangle
  final double? width;

  /// si c'est un cercle
  final double? radius;
}

class SkeletonWidgetState extends State<SkeletonWidget> //
    with
        SingleTickerProviderStateMixin {
  //
  late AnimationController controller;
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();
    //
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    //
    colorAnimation = ColorTween(
      begin: Themer.neural02Color,
      end: Themer.neural01Color,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // cercle
        if (widget.radius != null) {
          return CircleAvatar(backgroundColor: colorAnimation.value);
        }
        // rectangle
        else {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: ShapeDecoration(
              color: colorAnimation.value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
