import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
//import 'package:scan/scan.dart';

import '../../../domain/models/qrcode_data.dart';
import '../../../domain/models/qrcode_decode_error.dart';
import '../../../domain/models/qrcode_decode_exception.dart';
import '../../../ports/input/qrcode_input_port.dart';
import 'qrcode_scan_event.dart';
import 'qrcode_scan_state.dart';

class QrcodeScanBloc extends Bloc<QrcodeScanEvent, QrcodeScanState> {
  //
  final logger = Logger();

  //
  final QrcodeInputPort qrcodeInputPort;

  ///
  QrcodeScanBloc(this.qrcodeInputPort) : super(const QrcodeScanInitialState()) {
    //
    // Quand on scanne un qr code
    on<QrcodeScanDecodeEvent>(_onQrcodeScanDecodeEvent);
    // Quand on choisi une image qrcode depuis la galérie pour scan
    on<QrcodeScanSelectEvent>(_onQrcodeScanSelectEvent);
  }

  /// Quand on scanne un qr code
  void _onQrcodeScanDecodeEvent(
    QrcodeScanDecodeEvent event,
    Emitter<QrcodeScanState> emit,
  ) async {
    try {
      QrcodeData qrData = await qrcodeInputPort.decode(event.contenu);
      emit(QrcodeScanSuccessState(qrData));
    } //
    catch (e) {
      if (e is QrcodeDecodeException) {
        emit(QrcodeScanErrorState(e.error));
      } else {
        logger.e("Unexpected QR Code decode error", error: e);
        emit(const QrcodeScanErrorState(QrCodeDecodeError.unknown));
      }
    }
  }

  // Quand on choisi une image qrcode depuis la galérie
  void _onQrcodeScanSelectEvent(
    QrcodeScanSelectEvent event,
    Emitter<QrcodeScanState> emit,
  ) async {
    try {
      var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        // TODO review qr code scan package
        // String? qrCode = await Scan.parse(image.path);
        // if (qrCode != null) {
        //   QrcodeData qrData = await qrcodeInputPort.decode(qrCode);
        //   emit(QrcodeScanSuccessState(qrData));
        // }
        // // L'image n'est pas qrcode
        // else {
        //   emit(const QrcodeScanErrorState(
        //     QrCodeDecodeError.notQrImage,
        //   ));
        // }
      } else {
        emit(const QrcodeScanErrorState(QrCodeDecodeError.unknown));
      }
    }
    //
    catch (e) {
      if (e is QrcodeDecodeException) {
        emit(QrcodeScanErrorState(e.error));
      } else {
        logger.e("Unexpected QR Code decode error", error: e);
        emit(const QrcodeScanErrorState(QrCodeDecodeError.unknown));
      }
    }
  }
}
