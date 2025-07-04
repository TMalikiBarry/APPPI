import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/theme.dart';
import '../../../../../l10n/app_localizations.dart';
import 'introduction_item.dart';

class IntroductionVideo extends StatelessWidget {
  //
  final IntroductionItem item;
  final VideoPlayerController videoPlayerController;

  const IntroductionVideo({
    super.key,
    required this.videoPlayerController, //
    required this.item, //
  });

  ///
  @override
  Widget build(BuildContext context) {
    // Récupérer la taille de l'écran pour la responsivité des textes
    double hauteurEcran = MediaQuery.of(context).size.height;
    var textSize = Theme.of(context).textTheme.titleLarge!;
    if (hauteurEcran < 700) {
      textSize = Theme.of(context).textTheme.titleSmall!;
    }
    return Column(
      // Commencer par le haut
      mainAxisAlignment: MainAxisAlignment.start,
      // Centrer horizontalement
      crossAxisAlignment: CrossAxisAlignment.center,
      // Video, Welcome et titre
      children: [
        // Contenant de la vidéo fond blanc et bords arrondis
        Container(
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
              width: 0.5,
            ),
          ),
          child: Center(
            child: AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            ),
          ),
        ),
        // Distance qui séparent la vidéo du texte en dessous Welcome
        const SizedBox(height: 20),
        // Bienvenue
        Text(
          AppLocalizations.of(context)!.introductionLegende,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //color: const Color(0xFF282C5D),
                color: Themer.primaryLight,
              ),
        ),
        // Distance entre Bienvenue et titre de la vidéo
        const SizedBox(height: 10),
        // Titre de la vidéo introductive
        Padding(
          padding:const EdgeInsets.only(left: 30,right: 30) ,
          child: Text(
            item.titre,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Themer.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18
            ),
          ),),
      ],
    );
  }
}
