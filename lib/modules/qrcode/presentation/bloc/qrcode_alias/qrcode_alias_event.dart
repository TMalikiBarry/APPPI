import 'package:flutter/services.dart';

import '../../../../alias/domain/models/alias.dart';

abstract class QrcodeAliasEvent {
  const QrcodeAliasEvent();
}

class QrcodeAliasEncodeEvent extends QrcodeAliasEvent {
  final Alias alias;
  QrcodeAliasEncodeEvent(this.alias);
}

class QrcodeAliasShareEvent extends QrcodeAliasEvent {
  final String fileName;
  final String message;
  final Uint8List pngBytes;
  const QrcodeAliasShareEvent(this.fileName, this.message, this.pngBytes);
}
