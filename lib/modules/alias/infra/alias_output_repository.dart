import 'package:logger/logger.dart';

import '../../../core/api.dart';
import '../domain/exceptions/alias_retrieve_exception.dart';
import '../domain/models/alias.dart';
import '../domain/models/alias_create_command.dart';
import '../domain/models/alias_revendication.dart';
import '../domain/models/alias_type.dart';
import '../ports/output/alias_output_port.dart';
import 'alias_output_local.dart';
import 'alias_output_remote.dart';

class AliasOutputRepository implements AliasOutputPort {
  ///
  static final logger = Logger();

  /// Pour recuperer les données localement
  final AliasOutputLocal repoLocal = AliasOutputLocal();

  /// Pour enregistrer les données sur la base en ligne
  final AliasOutputRemote repoRemote = AliasOutputRemote();

  @override
  Future<void> envoyerOtp(String phone, String? channel) async {
    await repoRemote.envoyerOtp(phone, channel);
  }

  @override
  Future<Alias?> recuperer(String compte) async {
    try {
      // Tentative de récupération depuis le serveur distant
      final alias = await repoRemote.recuperer(compte);
      logger.d("Alias récupéré du serveur : $alias");
      print("Alias récupéré du serveur : $alias");
      logger.i(alias!.compte);

      if (alias != null) {
        // Sauvegarde en local si trouvé
        await repoLocal.enregistrer(alias);
      }

      return alias;
    } on AliasRetrieveException catch (e) {
      if (e.error == ApiError.notFound) {
        throw AliasRetrieveException(error: ApiError.notFound);
      }
      logger.w("Erreur AliasRetrieveException depuis le serveur", error: e);

      try {
        logger.d("compte : $compte");
        // Tentative de récupération depuis le local en fallback
        final aliasLocal = await repoLocal.recuperer(compte);

        // On relance une exception mais avec l'alias local (si trouvé)
        throw AliasRetrieveException(
          alias: aliasLocal,
          error: e.error,
          cause: e,
        );
      } catch (localError) {
        logger.e("Erreur récupération depuis le local", error: localError);
        throw AliasRetrieveException(
          alias: null,
          error: ApiError.unknowError,
          cause: localError,
        );
      }
    } catch (e) {
      // Cas général
      logger.e("Erreur inattendue lors de la récupération d'un alias", error: e);
      throw AliasRetrieveException(
        alias: null,
        error: ApiError.unknowError,
        cause: e,
      );
    }
  }

  @override
  Future<Alias> creer(AliasCreateCommand alias) async {
    Alias response = await repoRemote.creer(alias);
    // Une fois crée on l'enregistre en local
    if (alias.type == AliasType.shid) {
      repoLocal.enregistrer(response);
    }
    // Si c'est MBNO, l'alias n'est pas encore créé
    return response;
  }

  @override
  Future<Alias> confirmer(AliasCreateCommand alias, String otp, String? channel) async {
    Alias response = await repoRemote.confirmer(alias, otp, channel);
    repoLocal.enregistrer(response);
    return response;
  }

  @override
  Future<void> supprimer(String cle) async {
    await repoRemote.supprimer(cle);
    repoLocal.supprimer(cle);
  }

  @override
  Future<void> revendicationInitier(
    String compte,
    AliasCreateCommandPhoneNumber phone,
  ) async {
    await repoRemote.revendicationInitier(compte, phone);
  }

  @override
  Future<AliasRevendication?> revendicationRecuperer(String id) async {
    AliasRevendication? demande = await repoRemote.revendicationRecuperer(id);
    if (demande != null) {
      repoLocal.revendicationEnregistrer(demande);
    }
    return demande;

    //AliasRevendication? demande = await repoLocal.revendicationRecuperer(id);
    // AliasRevendication? demande = AliasRevendication(
    //   id: "+221776264787-1742918231158",
    //   alias: "+221776264787",
    //   statut: AliasRevendicationStatut.initiee,
    //   dateDemande: DateTime.parse("2025-03-25T15:57:11.158Z"),
    //   dateVerrouillage: DateTime.parse("2025-04-02T15:57:11.158Z"),
    //   dateCloture: DateTime.parse("2025-04-11T15:57:11.158Z"),
    // );
  }

  /// Répondre à une demande de revendication
  @override
  Future<AliasRevendication> revendicationRepondre(
    String id,
    bool decision,
    String? otpCode,
  ) async {
    AliasRevendication response = await repoRemote.revendicationRepondre(
      id,
      decision,
      otpCode,
    );
    if (decision) {
      // Supprimer l'alias MBNO en local
      repoLocal.supprimer(response.alias);
      // Creer l'alias  SHID en local
      repoLocal.enregistrer(response.shid!);
    }
    repoLocal.revendicationEnregistrer(response);
    return response;
  }
}
