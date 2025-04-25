import 'package:logger/logger.dart';

import '../domain/models/compte_details.dart';
import '../ports/output/compte_output_port.dart';
import 'compte_output_local.dart';
import 'compte_output_remote.dart';

class CompteOutputRepository implements CompteOutputPort {
  //
  CompteOutputRepository();

  /// Pour recuperer les données localement
  final CompteOutputLocal repoLocal = CompteOutputLocal();

  /// Pour enregistrer les données sur la base en ligne
  final CompteOutputRemote repoRemote = CompteOutputRemote();

  static final logger = Logger();

  @override
  Future<double?> getSolde(String compteId) async {
    try {
      double solde = await repoRemote.getSolde(compteId);
      repoLocal.enregistrerSolde(compteId, solde);
      return solde;
    } //
    catch (e) {
      logger.e("Erreur serveur", error: e);
      return await repoLocal.getSolde(compteId);
    }
  }

  @override
  Future<CompteDetails?> getDetails(String compteId) async {
    try {
      CompteDetails compteDetails = await repoRemote.getCompte(compteId);
      repoLocal.enregistrerDetails(compteId, compteDetails);
      return compteDetails;
    } //
    catch (e) {
      logger.e("Erreur serveur", error: e);
      return await repoLocal.getDetails(compteId);
    }
  }
}
