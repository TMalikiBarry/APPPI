import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/assets.dart';

class QrCodeAliasPageImage extends StatelessWidget {
  ///
  const QrCodeAliasPageImage({
    Key? key,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    required this.qrCode,
  }) : super(key: key);

  final String qrCode;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: QrImageView(
          data: qrCode,
          version: QrVersions.auto,
          gapless: false,
          padding: padding,
          embeddedImage: const AssetImage(Images.iconsPiOctogone,package: 'common_dependencies'),
          embeddedImageStyle: const QrEmbeddedImageStyle(
            size: Size(60, 60),
          ),
          eyeStyle: QrEyeStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            eyeShape: QrEyeShape.square,
          ),
          dataModuleStyle: QrDataModuleStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            dataModuleShape: QrDataModuleShape.circle,
          ),
        ),
      ),
    );
  }
}
