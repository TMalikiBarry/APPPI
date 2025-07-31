import '../../domain/models/alias.dart';
import '../../domain/models/alias_create_command.dart';
import '../../domain/models/alias_revendication.dart';

abstract class AliasOutputPort {
  ///
  /// Récupèrer l'alias du compte [compte]
  ///
  Future<Alias?> recuperer(String compte);

  ///
  /// Envoyer l'otp à l'utilisateur
  ///
  Future<void> envoyerOtp(String phone, String? channel);

  ///
  /// Créer l'alias de l'utilisateur
  ///
  Future<Alias> creer(AliasCreateCommand alias);

  ///
  /// Confirmer la création de l'alias de l'utilisateur
  ///
  Future<Alias> confirmer(AliasCreateCommand alias, String otp, String? channel);

  /// Suppression d'un alias
  Future<void> supprimer(String cle);

  /// Revendication d'un alias
  Future<void> revendicationInitier(
    String compte,
    AliasCreateCommandPhoneNumber phone,
  );

  /// Recuperer une demande de revendication
  Future<AliasRevendication?> revendicationRecuperer(String id);

  /// Répondre à une demande de revendication
  Future<AliasRevendication> revendicationRepondre(
    String id,
    bool decision,
    String? otpCode,
  );
}
