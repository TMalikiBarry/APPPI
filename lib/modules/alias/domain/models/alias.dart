import 'alias_type.dart';

class Alias {
  ///
  Alias({
    required this.cle,
    this.shid,
    required this.compte,
    required this.pays,
    required this.type,
  });

  final String cle;
  final String? shid;
  final String compte;
  // Pays du compte / participant
  final String pays;
  final AliasType type;

  /// Convertit du JSON en objet Alias
  factory Alias.fromJson(Map<dynamic, dynamic> json) {
    return Alias(
      cle: json['cle'] as String,
      shid: json['shid'] as String?,
      compte: json['compte'] as String,
      pays: json['pays'] as String,
      type: AliasType.values
          .firstWhere((element) => element.code == json['type'] as String),
    );
  }

  /// Convertit un objet Alias en JSON
  Map<String, dynamic> toJson() {
    return {
      'cle': cle,
      'compte': compte,
      'type': type.code,
      'pays': pays,
      'shid': shid
    };
  }
}
