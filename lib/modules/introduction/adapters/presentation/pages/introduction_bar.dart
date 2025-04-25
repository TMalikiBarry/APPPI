import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'introduction_item.dart';
import 'introduction_progressbar.dart';

class IntroductionBar extends StatelessWidget {
  //
  final IntroductionItem item;
  final int pageSize;
  final double progressBarWidth;
  final VideoPlayerController videoPlayerController;

  const IntroductionBar(
      {super.key,
      required this.videoPlayerController, //
      required this.item, //
      required this.pageSize, //
      required this.progressBarWidth //
      });

  ///
  @override
  Widget build(BuildContext context) {
    List<VideoProgressBar> barList = [];
    int widgetPosition = item.position;
    double barItemWidth = progressBarWidth;
    for (var i = 0; i < pageSize; i++) {
      // Si la page est antérieure à la page en cours
      if (i < widgetPosition) {
        barList.add(VideoProgressBar(
          videoPlayerController: null,
          progressBarItemWidth: barItemWidth,
          passed: true,
          current: false,
        ));
      }
      // si la page est à venir
      else if (i > widgetPosition) {
        barList.add(VideoProgressBar(
          videoPlayerController: null,
          progressBarItemWidth: barItemWidth,
          passed: false,
          current: false,
        ));
      }
      // sinon c'est la page actuelle
      else {
        barList.add(VideoProgressBar(
          videoPlayerController: videoPlayerController,
          progressBarItemWidth: barItemWidth,
          passed: false,
          current: true,
        ));
      }
    }
    return Row(
      // Centrez horizontalement les enfants
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: barList,
    );
  }
}
