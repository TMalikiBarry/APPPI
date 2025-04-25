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
