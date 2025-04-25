import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';

import '../../../domain/models/qrcode_encode_error.dart';
import '../../../ports/input/qrcode_input_port.dart';
import 'qrcode_alias_event.dart';
import 'qrcode_alias_state.dart';

class QrcodeAliasBloc extends Bloc<QrcodeAliasEvent, QrcodeAliasState> {
  ///
  final logger = Logger();

  ///
  final QrcodeInputPort qrcodeInputPort;

  ///
  QrcodeAliasBloc(this.qrcodeInputPort)
      : super(const QrcodeAliasInitialState()) {
    //
    // Quand on encode un alias en qr code
    on<QrcodeAliasEncodeEvent>(_onQrcodeAliasEncodeEvent);

    // Quand on partage l'image d'un qr code
    on<QrcodeAliasShareEvent>(_onQrcodeAliasShareEvent);
  }

  /// Quand on scanne un qr code
  void _onQrcodeAliasEncodeEvent(
    QrcodeAliasEncodeEvent event,
    Emitter<QrcodeAliasState> emit,
  ) async {
    try {
      String qrCode = await qrcodeInputPort.encode(event.alias);
      emit(QrcodeAliasEncodeSuccessState(qrCode));
    } //
    catch (e) {
      logger.e("Unexpected QR Code encode error", error: e);
      emit(const QrcodeAliasEncodeErrorState(QrCodeEncodeError.unknown));
    }
  }

  /// Quand on choisi une image qrcode depuis la galerie
  void _onQrcodeAliasShareEvent(
    QrcodeAliasShareEvent event,
    Emitter<QrcodeAliasState> emit,
  ) async {
    await Share.shareXFiles(
      [
        XFile.fromData(
          event.pngBytes,
          name: event.fileName,
          mimeType: 'image/png',
        ),
      ],
      subject: event.message,
    );
  }
}
