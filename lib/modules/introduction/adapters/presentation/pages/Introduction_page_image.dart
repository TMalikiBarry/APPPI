import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_mobile_app/modules/config/adapters/ui/bloc/config_event.dart';
import 'package:pi_mobile_app/modules/config/domain/models/config_keys.dart';

import '../../../../../core/router.dart';
import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/domain/models/config_keys.dart';
import 'introduction_bar_img.dart';
import 'introduction_footer.dart';
import 'introduction_image.dart';
import 'introduction_item_img.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward()
      ..addStatusListener((status) async {
        if (status == AnimationStatus.completed) {
          final isLast = widget.item.position == widget.pageSize - 1;
          if (isLast) {
            await secureStorage.write(key: 'isFirstTimeInPi', value: 'true');
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
              onPressed: () async {
                _ctrl.stop();
                // 1) on enregistre qu'on a passé l'intro
                await secureStorage.write(key: 'isFirstTimeInPi', value: 'true');
                context.read<ConfigBloc>().add(
                          const ConfigChangeEvent(
                            ConfigKey.introductionPassed,
                            "1",
                          ),
                        );
                // 2) puis on navigue vers HOME
                AppRouter.pushReplacement(context, AppRouter.home);
              },
              style: TextButton.styleFrom(
                backgroundColor: Themer.primaryColor.withOpacity(0.1),
                foregroundColor: Themer.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
              ),
              child: Text(traductions.ignore),
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