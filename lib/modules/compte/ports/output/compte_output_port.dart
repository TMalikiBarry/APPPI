import '../../domain/models/compte_details.dart';

abstract class CompteOutputPort {
  //

  /// Recuperer solde du compte identifié par [id]
  Future<double?> getSolde(String id);

  /// Recuperer les informations du compte identifié
  Future<CompteDetails?> getDetails(String compte);
}
