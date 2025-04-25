import '../domain/models/compte_details.dart';

class CompteEntity {
  CompteEntity({
    this.solde,
    this.details,
  });
  late double? solde;
  late CompteDetails? details;

  CompteEntity.fromJson(Map<dynamic, dynamic> json) {
    details = json['details'] != null
        ? CompteDetails.fromJson(json['details'])
        : null;
    solde = json['solde'] != null ? double.parse(json['solde'].toString()) : 0;
  }

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['details'] = details?.toJson();
    data['solde'] = solde?.toString();
    return data;
  }
}
