import 'package:common_dependencies/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingPage extends StatelessWidget {
  final Color? bgColor;
  final bool showClose;
  final VoidCallback? onClose;

  const LoadingPage({
    super.key,
    this.bgColor,
    this.showClose = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material( // permet d'afficher le bouton par-dessus (et gère le ripple)
      color: bgColor ?? Colors.transparent,
      child: Stack(
        children: [
          // Contenu central
          SizedBox.expand(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 100,
                child: LoadingAnimationWidget.flickr(
                  leftDotColor: primaryColor,
                  rightDotColor: secondaryColor,
                  size: 40,
                ),
              ),
            ),
          ),

          // Bouton close en haut à droite (SafeArea pour ne pas chevaucher le notch)
          if (showClose)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Material(
                    // petit fond circulaire pour rendre le bouton lisible
                    color: Colors.black.withOpacity(0.45),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: onClose ??
                              () {
                            Navigator.of(context).pop();
                          },
                      tooltip: 'Fermer',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomLoadingDialog {
  /// Affiche le loader
  static Future<void> show(
      BuildContext context, {
        bool showClose = false,
        VoidCallback? onClose,
      }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // on garde le comportement: fermer seulement via le bouton
      builder: (BuildContext dialogContext) {
        return LoadingPage(
          bgColor: Colors.transparent,
          showClose: showClose,
          onClose: onClose ??
                  () {
                Navigator.of(dialogContext).pop();
              },
        );
      },
    );
  }

  /// Cache le loader
  static void hide(BuildContext context) {
    // safe pop
    if (Navigator.canPop(context)) Navigator.of(context).pop();
  }
}