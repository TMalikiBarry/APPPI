import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import 'introduction_bar_img.dart';
import 'introduction_footer.dart';
import 'introduction_image.dart';
import 'introduction_item_img.dart';

// Un item introduction
class IntroductionPageItem extends StatefulWidget {
  //
  final IntroductionItem item;
  final int pageSize;
  final double progressBarWidth;
  final PageController pageController;

  const IntroductionPageItem({
    super.key, //
    required this.item, //
    required this.pageSize, //
    required this.pageController, //
    required this.progressBarWidth, //
  });

  @override
  IntroductionPageUnItemState createState() => IntroductionPageUnItemState();
}

class IntroductionPageUnItemState extends State<IntroductionPageItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          final isLast = widget.item.position == widget.pageSize - 1;
          if (isLast) {
            AppRouter.pushReplacement(context, AppRouter.home);
          } else {
            widget.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
          }
        }
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1) Barre de progression animée
          IntroductionBar(
            currentIndex:    widget.item.position,
            pageSize:        widget.pageSize,
            totalWidth:      widget.progressBarWidth * widget.pageSize,
            progress:        _ctrl,
          ),

          // 2) Skip button inchangé
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                _ctrl.stop();
                AppRouter.pushReplacement(context, AppRouter.home);
              },
              style: TextButton.styleFrom(
                backgroundColor: Themer.graySplash,
                foregroundColor: Themer.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
              ),
              child: const Text("Ignorer"),
            ),
          ),

          // 3) Affichage de l’image au lieu de la vidéo
          IntroductionImage(item: widget.item),

          // 4) Footer qui passe à la page suivante ou HOME
          IntroductionFooter(
            currentPage:    widget.item.position,
            pageSize:       widget.pageSize,
            pageController: widget.pageController,
            traductions:    traductions,
          ),
        ],
      ),
    );
  }
}