import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pi_mobile_app/core/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/assets.dart';

class QrCodeAliasPageImage extends StatelessWidget {
  ///
  const QrCodeAliasPageImage({
    Key? key,
    this.padding = const EdgeInsets.symmetric(vertical: 100.0, horizontal: 40.0),
    required this.qrCode,
  }) : super(key: key);

  final String qrCode;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container( // <-- fixe une taille à la carte
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6, // adapte selon ton besoin
        child: Stack(
          children: [
            // SVG en fond
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/qrCodePage.svg',
                fit: BoxFit.cover,
                package: 'common_dependencies',
              ),
            ),
            // QR code placé précisément
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: QrImageView(
                  size: MediaQuery.of(context).size.height * 0.5, // réduit si nécessaire
                  data: qrCode,
                  version: QrVersions.auto,
                  gapless: false,
                  padding: padding,
                  embeddedImage: const AssetImage(
                    Images.iconsPiOctogone,
                    package: 'common_dependencies',
                  ),
                  embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(40, 40)),
                  eyeStyle: const QrEyeStyle(
                    color: Themer.primaryColor,
                    eyeShape: QrEyeShape.square,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    color: Themer.primaryColor,
                    dataModuleShape: QrDataModuleShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
