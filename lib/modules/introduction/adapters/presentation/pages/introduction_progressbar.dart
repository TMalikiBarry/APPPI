import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressBar extends StatelessWidget {
  //
  final VideoPlayerController? videoPlayerController;
  final double progressBarItemWidth;
  final bool passed;
  final bool current;

  const VideoProgressBar({
    super.key, //
    required this.videoPlayerController, //
    required this.progressBarItemWidth, //
    required this.passed, //
    required this.current, //
  });

  @override
  Widget build(BuildContext context) {
    if (passed) {
      return _progressIndicator(
        context,
        width: progressBarItemWidth,
        progress: 1,
      );
    }
    // si en cours
    else if (current) {
      // A une frequence de 5Oms la progression de la video est renvoyée
      Stream<Duration> videoPositionStream = Stream.periodic(
        //
        const Duration(milliseconds: 50),
        (_) => videoPlayerController!.value.position,
      ).takeWhile((position) => videoPlayerController!.value.isPlaying);

      return StreamBuilder<Duration>(
        stream: videoPositionStream,
        builder: (context, snapshotStream) {
          if (snapshotStream.hasData) {
            // La valeur de progress est calculée en divisant la position
            // actuelle en millisecondes par la durée totale de la vidéo.
            // Cette valeur de progress est ensuite utilisée pour mettre à jour
            // la barre de progression dans le widget CustomProgressBar
            final double progress = snapshotStream.data!.inMilliseconds /
                videoPlayerController!.value.duration.inMilliseconds;

            return _progressIndicator(
              context,
              width: progressBarItemWidth,
              progress: progress.isNaN ? 0 : progress,
            );
          } else {
            return _progressIndicator(
              context,
              width: progressBarItemWidth,
              progress: 0,
            );
          }
        },
      );
    }
    // sinon pas encore
    {
      return _progressIndicator(
        context,
        width: progressBarItemWidth,
        progress: 0,
      );
    }
    // a chaque 5Oms la progression de lecture de video est renvoyée
    // sur widget [StreamBuilder<Duration>]
  }

  Container _progressIndicator(
    context, {
    required double width,
    required double progress,
  }) {
    double height = 3.0;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F1),
        borderRadius: BorderRadius.circular(height),
      ),
      child: Row(
        children: [
          Container(
            width: width * progress,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(height),
            ),
          ),
        ],
      ),
    );
  }
}
