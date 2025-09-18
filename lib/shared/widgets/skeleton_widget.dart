import 'package:common_dependencies/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SkeletonWidget extends StatefulWidget {
  ///
  const SkeletonWidget({
    super.key,
    this.height = 15,
    this.width = 200,
    this.radius,
    this.isList = true, Color? color,
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

  final bool isList;
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
    // cercle
    if (widget.radius != null) {
      return CircleAvatar(backgroundColor: colorAnimation.value);
    }
    if (widget.isList) {
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
    } else {

      // rectangle avec effet d'animation à l'intérieur
      return Center(
        child: Container(
          alignment: Alignment.center,
          width: widget.width,
          height: widget.height,
          //margin: EdgeInsets.only(top: 125.0 * ffem),
          child: LoadingAnimationWidget.flickr(
            leftDotColor: whiteColor,
            rightDotColor: secondaryColor,
            size: 40,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
