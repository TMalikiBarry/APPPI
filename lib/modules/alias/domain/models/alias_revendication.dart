import 'alias.dart';

enum AliasRevendicationStatut {
  initiee("INITIEE"),
  rejetee("REJETEE"),
  acceptee("ACCEPTEE");

  final String value;
  const AliasRevendicationStatut(this.value);

  static AliasRevendicationStatut get(String name) {
    return AliasRevendicationStatut.values.firstWhere(
      (e) => e.value == name,
      orElse: () =>
          throw ArgumentError("Aucune correspondance pour la valeur $name"),
    );
  }
}

class AliasRevendication {
  //
  AliasRevendication({
    required this.id,
    required this.alias,
    required this.statut,
    required this.dateDemande,
    required this.dateVerrouillage,
    required this.dateCloture,
    this.dateAction,
    this.shid,
  });

  final String id;
  final String alias;
  final AliasRevendicationStatut statut;
  final DateTime dateDemande;
  final DateTime dateVerrouillage;
  final DateTime dateCloture;
  final DateTime? dateAction;
  final Alias? shid;

  static AliasRevendication fromJson(Map<dynamic, dynamic> json) {
    return AliasRevendication(
      id: json['id'] as String,
      alias: json['alias'] as String,
      statut: AliasRevendicationStatut.get(json['statut'] as String),
      dateDemande: DateTime.parse(json['dateDemande'] as String),
      dateVerrouillage: DateTime.parse(json['dateVerrouillage'] as String),
      dateCloture: DateTime.parse(json['dateCloture'] as String),
      dateAction: json['dateAction'] != null
          ? DateTime.parse(json['dateAction'] as String)
          : null,
      shid: json['shid'] != null ? Alias.fromJson(json['shid']) : null,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': id,
      'alias': alias,
      'statut': statut.name,
      'dateDemande': dateDemande.toIso8601String(),
      'dateVerrouillage': dateDemande.toIso8601String(),
      'dateCloture': dateDemande.toIso8601String(),
      'dateAction': dateAction?.toIso8601String(),
      'shid': shid?.toJson(),
    };
  }
}
