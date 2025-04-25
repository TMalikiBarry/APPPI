import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:pi_mobile_app/l10n/app_localizations.dart';

import '../../../../../core/assets.dart';
import '../../../../core/router.dart';
import '../../../../shared/widgets/menu_actions_widget.dart';
import '../bloc/qrcode_alias/qrcode_alias_bloc.dart';
import '../bloc/qrcode_alias/qrcode_alias_event.dart';

class QrcodeAliasPageShare extends StatelessWidget {
  //

  const QrcodeAliasPageShare({
    Key? key,
    required this.globalKey,
    required this.username,
    required this.qrcodeAliasBloc,
  }) : super(key: key);

  final QrcodeAliasBloc qrcodeAliasBloc;
  final GlobalKey globalKey;
  final String username;

  @override
  Widget build(BuildContext context) {
    AppLocalizations traductions = AppLocalizations.of(context)!;
    //
    //
    return SizedBox(
      height: 280,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Title
              Text(
                traductions.qrcodePagePartageTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              //
              const SizedBox(height: 20),
              //
              MenuActionsWiget(items: [
                // Share Qr Code
                MenuActionItem(
                  Images.homeFooterQrcode,
                  traductions.qrcodePagePartageQrCodeTitle,
                  traductions.qrcodePagePartageQrCodeSubTitle,
                  () => _shareQRCode(qrcodeAliasBloc)
                      .then((value) => AppRouter.pop(context)),
                  iconSize: 20,
                ),
                // Share Alias only
                MenuActionItem(
                  Images.aliasIconUser,
                  traductions.qrcodePagePartageAliasTitle,
                  traductions.qrcodePagePartageAliasSubTitle,
                  () => _shareAlias(context, qrcodeAliasBloc)
                      .then((value) => AppRouter.pop(context)),
                  iconSize: 20,
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function de partage du qr code
  Future<void> _shareQRCode(
    QrcodeAliasBloc qrcodeAliasBloc,
  ) async {
    // Obtention de l'image du code QR
    // On récupère l'objet RenderRepaintBoundary qui représente la partie de
    // l'interface utilisateur à capturer.
    // globalKey est une clé globale associée à cet élément.
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    // Conversion de l'image en données
    // On convertit l'objet RenderRepaintBoundary en une image (ui.Image)
    ui.Image image = await boundary.toImage();
    // Ensuite, on convertit cette image en données (ByteData) au format PNG.
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Conversion des données en tableau d'octets (Uint8List)
    // On convertit les données en un tableau d'octets (Uint8List),
    // ce qui représente l'image au format PNG
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    //
    // On crée un emet événement (QrcodeAliasShareEvent) avec des informations
    // telles que le nom du fichier, la description
    // et les données de l'image à partagé
    qrcodeAliasBloc.add(
      QrcodeAliasShareEvent(
        // Nom du fichier image
        'spi-qrcode-$username.png',
        // la description
        'SPI qrCode de $username',
        // les données de l'image à partagé
        pngBytes,
      ),
    );
  }

  Future<void> _shareAlias(
    BuildContext context,
    QrcodeAliasBloc qrcodeAliasBloc,
  ) async {
    // Todo share with name so we can save in contact
  }
}
