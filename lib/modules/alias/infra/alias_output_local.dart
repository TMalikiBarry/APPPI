import 'package:logger/logger.dart';
import 'package:pi_mobile_app/core/api.dart';

import '../../../core/storage.dart';
import '../domain/models/alias.dart';
import '../domain/models/alias_revendication.dart';

class AliasOutputLocal {
  ///
  static final logger = Logger();

  ///
  static const String collectionId = "alias";
  static const String revendicationCollectionId = "alias_revendication";

  Future<void> enregistrer(Alias alias) async {
    try {
      await AppStorage.save(collectionId, alias.compte, alias.toJson());
      logger.e("Sauvegarde en local avec success");
    } catch (e) {
      logger.e("Erreur lors de l'enregistrement locale de l'alias", error: e);
      throw Exception("Erreur lors de l'enregistrement locale");
    }
  }

  Future<Alias?> recuperer(String cle) async {
    try {
      return await AppStorage.get(
        collectionId,
        cle,
            (json) => Alias.fromJson(json),
      );
    } catch (e) {
      logger.e("Erreur lors de la récupération locale de l'alias", error: e);
      throw Exception("Erreur lors de la récupération locale");
    }
  }

  Future<void> supprimer(String cle) async {
    await AppStorage.delete(
      collectionId,
      cle,
    );
  }

  Future<void> revendicationEnregistrer(AliasRevendication demande) async {
    await AppStorage.save(
      revendicationCollectionId,
      demande.id,
      demande.toJson(),
    );
  }

  Future<AliasRevendication?> revendicationRecuperer(String id) async {
    return await AppStorage.get(
      revendicationCollectionId,
      id,
      (json) => AliasRevendication.fromJson(json),
    );
  }
}
