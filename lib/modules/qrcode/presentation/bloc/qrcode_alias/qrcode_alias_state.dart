import '../../../domain/models/qrcode_encode_error.dart';

abstract class QrcodeAliasState {
  const QrcodeAliasState();
}

class QrcodeAliasInitialState extends QrcodeAliasState {
  const QrcodeAliasInitialState();
}

class QrcodeAliasEncodeSuccessState extends QrcodeAliasState {
  const QrcodeAliasEncodeSuccessState(this.qrCode);
  final String qrCode;
}

class QrcodeAliasEncodeErrorState extends QrcodeAliasState {
  const QrcodeAliasEncodeErrorState(this.error);
  final QrCodeEncodeError error;
}
