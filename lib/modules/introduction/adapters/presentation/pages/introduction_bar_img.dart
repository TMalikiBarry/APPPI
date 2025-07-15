import 'package:common_dependencies/utils/colors.dart' as Colors;
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class IntroductionBar extends StatelessWidget {
  final int currentIndex;
  final int pageSize;
  final double totalWidth;
  final Animation<double> progress;

  const IntroductionBar({
    super.key,
    required this.currentIndex,
    required this.pageSize,
    required this.totalWidth,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final segmentWidth = (totalWidth / pageSize) - 4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(pageSize, (i) {
        if (i < currentIndex) {
          // déjà passé
          return Container(width: segmentWidth, height: 4, color: Colors.grey);
        } else if (i == currentIndex) {
          // segment en cours (animé)
          return AnimatedBuilder(
            animation: progress,
            builder: (_, __) {
              return Stack(children: [
                Container(width: segmentWidth, height: 4, color: Colors.white.withAlpha(24)),
                Container(width: segmentWidth * progress.value, height: 4, color: Colors.grey),
              ]);
            },
          );
        } else {
          // à venir
          return Container(width: segmentWidth, height: 4, color: Colors.white.withAlpha(24));
        }
      }),
    );
  }
}