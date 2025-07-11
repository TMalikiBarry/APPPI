import 'package:flutter/material.dart';

import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import 'introduction_item.dart';
import 'introduction_page.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  ///
  @override
  Widget build(BuildContext context) {
    //
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Légende affichée sous les vidéos
    final String legende = localizations.introductionLegende;

    // final String lang = localizations.localeName;
    const String lang = "fr";
    print("&&&&&& LOGGERR LANG $lang");
    // Liste d'éléments d'introduction
    final List<IntroductionItem> itemList = [
      IntroductionItem(
        'assets/videos/onboardingnew_${lang}_1.mp4',
        // 'assets/videos/onboarding_${lang}_2.mp4',
        legende,
        localizations.introductionItem1,
        0,
      ),
      IntroductionItem(
        'assets/videos/onboardingnew_${lang}_2.mp4',
        legende,
        localizations.introductionItem2,
        1,
      ),
      IntroductionItem(
        'assets/videos/onboardingnew_${lang}_3.mp4',
        legende,
        localizations.introductionItem3,
        2,
      ),
      IntroductionItem(
        'assets/videos/onboardingnew_${lang}_4.mp4',
        legende,
        localizations.introductionItem4,
        3,
      ),
      IntroductionItem(
        'assets/videos/onboardingnew_${lang}_5.mp4',
        legende,
        localizations.introductionItem5,
        4,
      ),
      /*IntroductionItem(
        'assets/videos/onboardingnew_${lang}_6.mp4',
        legende,
        localizations.introductionItem6,
        5,
      ),*/
    ];
    final nbItems = itemList.length;
    // Marge horizontale
    const double paddingX = 20;
    // Largeur barre de progression
    double progressBarWidth =
        MediaQuery.of(context).size.width - (paddingX * 2);
    double progressBarItemWidth = (progressBarWidth / nbItems) - 4;

    // Commencer la construction de la page
    return Scaffold(
      backgroundColor: Themer.moonColor2,
      body: SafeArea(
        // Lazy load page
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemCount: nbItems,
              itemBuilder: (context, index) {
                return IntroductionPageItem(
                  item: itemList[index],
                  pageSize: nbItems,
                  pageController: _pageController,
                  progressBarWidth: progressBarItemWidth,
                );
              },
            ),
            // Zones cliquables invisibles sur les côtés
            Positioned.fill(
              child: Row(
                children: [
                  // Zone gauche (25%)
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_currentPage > 0) {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                    ),
                  ),

                  // Zone centrale (50% - non cliquable)
                  Expanded(flex: 2, child: Container()),

                  // Zone droite (25%)
                  /*Expanded(
                    flex: 1,
                    child: GestureDetector(
                      // behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_currentPage < nbItems - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
