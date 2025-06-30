import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../../l10n/app_localizations.dart';
import 'introduction_bar.dart';
import 'introduction_footer.dart';
import 'introduction_item.dart';
import 'introduction_video.dart';

/// Un item introduction
class IntroductionPageItem extends StatefulWidget {
  //
  final IntroductionItem item;
  final int pageSize;
  final double progressBarWidth;

  const IntroductionPageItem({
    super.key, //
    required this.item, //
    required this.pageSize, //
    required this.progressBarWidth, //
  });

  @override
  IntroductionPageUnItemState createState() => IntroductionPageUnItemState();
}

/// Etat d'un item introduction - vidéo de présentation
class IntroductionPageUnItemState extends State<IntroductionPageItem> {
  //
  late VideoPlayerController videoPlayerController;
  late Future<void> _videoInitializer;

  ///
  @override
  void initState() {
    super.initState();

    setState(() {
      videoPlayerController = VideoPlayerController.asset(widget.item.video, package: 'common_dependencies');
      _videoInitializer = videoPlayerController.initialize();
      videoPlayerController.setLooping(true);
      videoPlayerController.setVolume(1.0);
      videoPlayerController.play();
    });
  }

  ///
  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      child: Center(
        child: FutureBuilder(
          future: _videoInitializer,
          builder: (context, snapshotPlayer) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // barre de progression
                IntroductionBar(
                    videoPlayerController: videoPlayerController,
                    item: widget.item,
                    pageSize: widget.pageSize,
                    progressBarWidth: widget.progressBarWidth),
                // Video et titres
                IntroductionVideo(
                  videoPlayerController: videoPlayerController,
                  item: widget.item,
                ),
                // Pied de la page
                IntroductionFooter(
                  item: widget.item,
                  pageSize: widget.pageSize,
                  traductions: traductions,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
