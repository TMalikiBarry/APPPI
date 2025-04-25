import '../../../domain/models/qrcode_data.dart';
import '../../../domain/models/qrcode_decode_error.dart';

abstract class QrcodeScanState {
  const QrcodeScanState();
}

class QrcodeScanInitialState extends QrcodeScanState {
  const QrcodeScanInitialState();
}

class QrcodeScanSuccessState extends QrcodeScanState {
  const QrcodeScanSuccessState(this.data);
  final QrcodeData data;
}

class QrcodeScanErrorState extends QrcodeScanState {
  const QrcodeScanErrorState(this.error);
  final QrCodeDecodeError error;
}
