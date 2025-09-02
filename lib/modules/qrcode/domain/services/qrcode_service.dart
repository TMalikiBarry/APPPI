import 'dart:convert';

import 'package:emvqrcode/emvqrcode.dart';
import 'package:logger/logger.dart';

import '../../../../shared/models/uemoa_countries.dart';
import '../../../alias/domain/models/alias.dart';
import '../../../alias/domain/models/alias_type.dart';
import '../../../security/domain/models/connected_user.dart';
import '../../ports/input/qrcode_input_port.dart';
import '../models/qrcode_data.dart';
import '../models/qrcode_decode_error.dart';
import '../models/qrcode_decode_exception.dart';
import '../models/qrcode_encode_error.dart';
import '../models/qrcode_encode_exception.dart';

class QrcodeService implements QrcodeInputPort {
  /// Format de numéro de téléphone des 8 pays de l'union
  static const patternMBNO =
      r'^(?:\+225\d{10}|\+221(77|76|70|78|75|71)\d{7}|\+223\d{8}|\+226\d{8}|\+229\d{8}|\+228\d{8}|\+227\d{8}|\+245\d{6})$';

  /// Pattern alias SHID
  static const patternSHID =
      r'^[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}$';

  /// QR Code GUI
  static String globallyUniqueIdentifier = "int.bceao.pi";

  /// Devise XOF code
  static String currency = "952";

  ///
  static final logger = Logger();

  @override
  Future<QrcodeData> decode(String data) async {
    String? alias;
    String? txId;
    String? montant;
    String? channel;
    dynamic emvDecode;

    logger.i("qrcode String data ------> $data");

    emvDecode = EMVMPM.decode(data);

    logger.i("qrcode emv format ------> ${emvDecode.toJson()}");

    final emvModel = emvDecode.emvqr;
    if (emvModel == null) {
      throw QrcodeDecodeException(QrCodeDecodeError.invalidFormat);
    }
    logger.i('''qrcode additionalDataFieldTemplate ------> 
        ${emvModel.additionalDataFieldTemplate?.value?.toJson()}''');

    // GloballyUniqueIdentifier
    final gUI = emvModel.merchantAccountInformation?["36"]?.value
        ?.globallyUniqueIdentifier?.value;
    logger.i("qrcode gui value ------> $gUI");
    if (gUI != globallyUniqueIdentifier) {
      throw QrcodeDecodeException(
        QrCodeDecodeError.notInteroperable,
        cause: "GUI",
      );
    }

    // transactionCurrency
    final txCcy = emvModel.transactionCurrency?.value;
    logger.i("qrcode txCcy value ------> $txCcy");
    if (txCcy != currency) {
      throw QrcodeDecodeException(
        QrCodeDecodeError.notInteroperable,
        cause: "Currency",
      );
    }

    // countryCode
    final countryCode = emvModel.countryCode?.value;
    logger.i("qrcode cuntCd value ------> $countryCode");
    if (countryCode == null || !UEMOACountry.isExist(countryCode)) {
      throw QrcodeDecodeException(QrCodeDecodeError.notInteroperable);
    }

    // Recuperation de l'alias
    alias = emvModel.merchantAccountInformation?["36"]?.value
        ?.paymentNetworkSpecific?[0].value;
    logger.i("qrcode alias value ------> $alias");
    if (alias == null || (!RegExp(patternSHID).hasMatch(alias) && !RegExp(patternMBNO).hasMatch(alias))) {
      throw QrcodeDecodeException(QrCodeDecodeError.invalidAlias);
    }

    // Recuperation du Montant
    montant = emvModel.transactionAmount?.value;
    logger.i("qrcode montant value ------> $montant");

    // Recuperation du Channel
    channel =
        emvModel.additionalDataFieldTemplate?.value?.merchantChannel?.value;
    logger.i("qrcode channel value ------> $channel");
    if (channel == null) {
      throw QrcodeDecodeException(QrCodeDecodeError.invalidChannel);
    }

    // Recuperation du TxId
    txId = emvModel.additionalDataFieldTemplate?.value?.referenceLabel?.value;
    logger.i("qrcode txId value ------> $txId");
    //
    return QrcodeData(
      alias,
      txId,
      montant != null ? double.tryParse(montant) : null,
      channel,
    );
  }

  // Génération du qr code pour une personne physique
  @override
  Future<String> encode(Alias alias) async {
    EMVQR emv = EMVQR();
    emv.setPayloadFormatIndicator("01");
    emv.setTransactionCurrency(currency);
    emv.setCountryCode(alias.pays);
    /// merchant account information
    MerchantAccountInformation mAccountInfo = MerchantAccountInformation();
    mAccountInfo.setGloballyUniqueIdentifier(globallyUniqueIdentifier);
    mAccountInfo.addPaymentNetworkSpecific(
      id: "01",
      value: //"246bd9aa-8bf6-4783-b01d-318042e60cd8"
      ConnectedUser.current != null && ConnectedUser.current?.shid != null ? ConnectedUser.current?.shid
       : alias.shid ?? alias.cle,
    );
    emv.addMerchantAccountInformation(id: "36", value: mAccountInfo);

    // merchant info language
    MerchantInformationLanguageTemplate mInfoLang =
        MerchantInformationLanguageTemplate();
    mInfoLang.setMerchantCity("X");
    mInfoLang.setMerchantName("X");
    emv.setMerchantInformationLanguageTemplate(mInfoLang);

    // Pour tester montant dans QR cdynamique emv.setTransactionAmount("10000");

    // Additional Field
    AdditionalDataFieldTemplate additionalData = AdditionalDataFieldTemplate();
    // TxId = additionalData.setReferenceLabel("TXID-78585225855");
    // TxadditionalData.setMerchantChannel("400"); // Personne morale QR Dynamique
    additionalData.setMerchantChannel("731"); // Personne physique
    emv.setAdditionalDataFieldTemplate(additionalData);

    // encode data to emvCo
    final emvEncode = EMVMPM.encode(emv);
    logger.i("emv encode -------> ${emvEncode.toJson()}");

    if (emvEncode.error != null) {
      throw QrcodeEncodeException(
        QrCodeEncodeError.unknown,
        cause: emvEncode.error!,
      );
    } else {
      return emvEncode.value!;
    }
  }
}
