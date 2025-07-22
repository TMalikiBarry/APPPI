import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/router.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../../config/adapters/ui/bloc/config_event.dart';
import '../../../../config/domain/models/config_keys.dart';
import 'introduction_item.dart';

class IntroductionFooter extends StatelessWidget {
  final int currentPage;
  final int pageSize;
  final PageController pageController;
  final AppLocalizations traductions;

  const IntroductionFooter({
    super.key,
    required this.currentPage,
    required this.pageSize,
    required this.pageController,
    required this.traductions,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLast = currentPage == pageSize - 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: ElevatedButton(
        onPressed: () {
          if (isLast) {
            context
                .read<ConfigBloc>()
                .add(const ConfigChangeEvent(ConfigKey.introductionPassed, "1"));
            // 🎯 Sur la dernière page, on redirige HOME
            AppRouter.pushReplacement(
              context,
              AppRouter.home,
            );
          } else {
            // 🔜 sinon on passe à la page suivante
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
          backgroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
        ),
        child: Icon(
          isLast
              ? Icons.check // ou autre icône “terminé”
              : Icons.arrow_forward_ios_outlined,
          color: isLast ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}

/*class IntroductionFooter extends StatelessWidget {
  //
  final IntroductionItem item;
  final int pageSize;
  final AppLocalizations traductions;

  ///
  const IntroductionFooter({
    super.key, //
    required this.item, //
    required this.pageSize, //
    required this.traductions, //
  });

  ///
  @override
  Widget build(BuildContext context) {
    //if (item.position == pageSize - 1) {
      // Bouton suivant
      return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: ElevatedButton(
            onPressed: () {
              context
                  .read<ConfigBloc>()
                  .add(const ConfigChangeEvent(ConfigKey.introductionPassed, "1"));
              AppRouter.pushReplacement(context, AppRouter.home);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black26,
            ),
            child: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.red),
          ),
      );

   *//* } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            traductions.introductionFooterTitle,
            style: Theme.of(context)
                .textTheme //
                .bodyLarge
                ?.copyWith(
                  color: Themer.whiteColor,
                ),
          ),
          const SizedBox(height: 5.0),
          Text(
            traductions.introductionFooterSubtitle,
            style: Theme.of(context)
                .textTheme //
                .bodyLarge
                ?.copyWith(
                  color: Themer.amberColor,
                ),
          )
        ],
      );
    }*//*
  }
}*/
