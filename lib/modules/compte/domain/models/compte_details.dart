import 'package:common_dependencies/models/user/account/account.dart';

import 'client.dart';
import 'compte.dart';
import 'compte_alias.dart';

class CompteDetails {
  CompteDetails({
    required this.client,
    required this.compte,
    required this.alias,
  });
  late Client client;
  late Compte compte;
  late CompteAlias alias;

  CompteDetails.fromJson(Map<dynamic, dynamic> json) {
    client = Client.fromJson(json['client']);
    compte = Compte.fromJson(json['compte']);
    alias = CompteAlias.fromJson(json['alias']);
  }

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> data = <String, dynamic>{};
    data['client'] = client.toJson();
    data['compte'] = compte.toJson();
    data['alias'] = alias.toJson();
    return data;
  }
}

extension ResponseDataMapper on ResponseData {
  /// Transforme ce ResponseData en modèle CompteDetails
  CompteDetails toCompteDetails() {
    // 1) Client
    final client = Client(
      nom:                        label,
      categorie:                  category,
      nationalite:                country.language,
      paysResidence:              country.countryName,
      telephone:                  legalEntity.phoneContact?? ' --- ',
      genre:                      '', // pas d'information dans ResponseData
      identificationNationale:    '', // idem
      email:                      legalEntity.emailContact,
      adresse:                    legalEntity.address,
      codePostale:                null,
      dateNaissance:              null,
      paysNaissance:              null,
      villeNaissance:             null,
      nomMere:                    null,
      photo:                      null,
      numeroPasseport:            null,
    );

    // 2) Compte
    final compte = Compte(
      participant:   legalEntity.code,
      agence:        legalEntity.code,           // ou autre champ s’il existe
      numero:        accountNumber,
      type:          accountTypes.isNotEmpty
          ? accountTypes.first.code
          : '',
      // dateOuverture: balance.lastUpdatedDate ?? '',
      dateOuverture: ' --- ',
    );

    // 3) Alias
    final alias = CompteAlias(
      cle:  accountNumber,
      type: accountTypes.isNotEmpty
          ? accountTypes.first.category
          : '',
      shid: null,
    );

    return CompteDetails(
      client: client,
      compte: compte,
      alias:  alias,
    );
  }
}
