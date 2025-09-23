import 'package:common_dependencies/utils/utils.dart';
import 'package:pi_mobile_app/modules/security/domain/models/connected_user.dart';

import 'alias_type.dart';

class Alias {
  ///
  Alias({
    required this.cle,
    this.shid,
    this.participant,
    required this.compte,
    required this.pays,
    required this.type,
    this.accountType
  });

  final String cle;
  final String? shid;
  final String? participant;
  final String compte;
  // Pays du compte / participant
  final String pays;
  final AliasType type;
  final String? accountType;

  /// Convertit du JSON en objet Alias
  factory Alias.fromJson(Map<dynamic, dynamic> json) {
    /*logger.i("json alias : $json");
    json.forEach((key, value) {
      logger.i("$key: $value  (type: ${value.runtimeType})");
    });*/

    final String? typeCode = json['aliasType'] ?? json['type'];

    return Alias(
      cle: (json['alias'] ?? json['cle']) as String,
      shid: json['shid'] as String?,
      compte: (json['clientPhoneNumber'] ?? json['compte']) as String,
      pays: (json['clientResidenceCountry'] ?? json['pays']) as String,
      participant: json['participant'] as String?,
      type: AliasTypeExtension.fromCode(typeCode.toString()),
      accountType: json['accountType'] as String?,
    );
  }

  /// Convertit un objet Alias en JSON
  Map<String, dynamic> toJson() {
    return {
      'cle': cle,
      'compte': compte,
      'type': type.code,
      'pays': pays,
      'participant': participant,
      'shid': shid ?? ConnectedUser.current!.shid,
      'accountType' : accountType
    };
  }
}

extension AliasTypeExtension on AliasType {
  static AliasType fromCode(String code) {
    return AliasType.values.firstWhere(
          (e) => e.code == code,
      orElse: () {
        logger.e("AliasType inconnu: $code");
        return AliasType.values.first;
      },
    );
  }
}
