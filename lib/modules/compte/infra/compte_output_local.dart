import 'package:logger/logger.dart';

import '../../../core/storage.dart';
import '../domain/models/compte_details.dart';
import 'compte_entity.dart';

class CompteOutputLocal {
  ///
  static final logger = Logger();

  ///
  static const String collectionId = "compte";

  /// Solde du compte
  Future<void> enregistrerSolde(String compteId, double solde) async {
    // Recuperer details
    CompteEntity? compte = await AppStorage.get(
      collectionId,
      compteId,
      (json) => CompteEntity.fromJson(json),
    );
    //
    if (compte != null) {
      compte.solde = solde;
    } else {
      compte = CompteEntity(solde: solde);
    }
    await AppStorage.save(collectionId, compteId, compte.toJson());
  }

  /// Details du compte
  Future<void> enregistrerDetails(
    String compteId,
    CompteDetails compteDetails,
  ) async {
    // Recuperer details
    CompteEntity? compte = await AppStorage.get(
      collectionId,
      compteId,
      (json) => CompteEntity.fromJson(json),
    );
    //
    if (compte != null) {
      compte.details = compteDetails;
    } else {
      compte = CompteEntity(details: compteDetails);
    }
    await AppStorage.save(collectionId, compteId, compte.toJson());
  }

  /// Recuperer le dernier solde enregistré
  Future<double?> getSolde(String id) async {
    dynamic compteDetails =
        await AppStorage.get(collectionId, id, (json) => json);
    if (compteDetails != null) {
      String solde =
          (compteDetails as Map<dynamic, dynamic>)["solde"].toString();
      return double.parse(solde);
    } else {
      return null;
    }
  }

  /// Recuperer les details du compte
  Future<CompteDetails?> getDetails(String compteId) async {
    dynamic compteDetails =
        await AppStorage.get(collectionId, compteId, (json) => json);
    if (compteDetails != null) {
      return CompteDetails.fromJson((compteDetails as Map<String, dynamic>));
    } else {
      return null;
    }
  }
}
