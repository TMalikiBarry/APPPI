import '../../domain/models/alias.dart';
import '../../domain/models/alias_create_command.dart';
import '../../domain/models/alias_mbno_otp_command.dart';
import '../../domain/models/alias_revendication.dart';

abstract class AliasInputPort {
  //
  /// Récupèrer l'alias de l'utilisateur
  ///
  Future<Alias?> recuperer(String compte);

  //
  /// Envoyer l'otp à l'utilisateur
  ///
  Future<void> envoyerOtp(String phone, String? channel);

  //
  /// Créer l'alias de l'utilisateur
  ///
  Future<Alias> creer(AliasCreateCommand alias);

  //
  /// Confirmer la création de l'alias type MBNO en envoyant le code OTP reçu
  ///
  Future<Alias> confirmer(AliasMbnoOtpCommand otp, AliasCreateCommand alias);

  /// Suppression d'un alias
  Future<void> supprimer(String cle);

  /// Revendiquer un alias
  Future<void> revendiquer(String compte, AliasCreateCommandPhoneNumber phone);

  /// Récupérer une revendication d alias
  Future<AliasRevendication?> recupererRevendication(String id);

  /// Accepter ou rejeter une revendication un alias
  Future<AliasRevendication> repondreRevendication(
    String id,
    bool decision,
    String? otpCode,
  );
}
