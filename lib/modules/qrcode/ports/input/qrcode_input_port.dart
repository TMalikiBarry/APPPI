import '../../../alias/domain/models/alias.dart';
import '../../domain/models/qrcode_data.dart';

abstract class QrcodeInputPort {
  //
  /// Permet de décoder un QR Code EMV
  Future<QrcodeData> decode(String data);

  /// Permet d'encoder un QR Code EMV à partir de l'alias
  Future<String> encode(Alias alias);
}
