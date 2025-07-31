import '../../domain/models/alias.dart';
import '../../domain/models/alias_create_command.dart';
import '../../domain/models/alias_mbno_otp_command.dart';
import '../../domain/models/alias_revendication.dart';

abstract class AliasEvent {
  const AliasEvent();
}

/// Quand on shouaite recupérer l'alias de compte
class FetchAliasEvent extends AliasEvent {
  final String compte;

  FetchAliasEvent(this.compte);
}

/// ---------------------
/// Address alias
/// ---------------------

/// Quand on shouaite créer un alias de type SHID
class CreateAliasSHIDEvent extends AliasEvent {
  final String compte;

  CreateAliasSHIDEvent(this.compte);
}

/// ---------------------
/// Phone number alias
/// ---------------------
class CreateAliasMBNOEvent extends AliasEvent {
  final String compte;

  CreateAliasMBNOEvent(this.compte);
}

class CreateAliasMBNOValidationEvent extends AliasEvent {
  final AliasCreateCommand values;
  CreateAliasMBNOValidationEvent(this.values);
}

/// Quand on shouaite envoyé un code otp
class AskPhoneNumberVerificationEvent extends AliasEvent {
  //
  final AliasCreateCommand values;
  //
  final String? channel;
  AskPhoneNumberVerificationEvent(this.values, this.channel);
}

/// Quand on shouaite verifier un code otp envoyé sur un numéro
class CheckPhoneNumberVerificationEvent extends AliasEvent {
  //
  const CheckPhoneNumberVerificationEvent(
    this.values,
    this.digit,
    this.position,
    this.otpCode,
  );
  // Alias
  final AliasCreateCommand values;
  // Numero selectionne
  final int digit;
  // Position du numéro
  final int position;
  // Code  otp
  final AliasMbnoOtpCommand otpCode;
}

//
/// Quand on shouaite supprimer un alias
class AliasDeleteEvent extends AliasEvent {
  //
  final String cle;
  AliasDeleteEvent(this.cle);
}

//
/// Quand on veut revendiquer un alias
class AliasClaimAskEvent extends AliasEvent {
  //
  final String compte;
  AliasCreateCommandPhoneNumber phoneNumber;

  AliasClaimAskEvent({required this.compte, required this.phoneNumber});
}

/// Quand on souhaite recuperer une revendication d'alias
class AliasClaimFetchEvent extends AliasEvent {
  final String id;
  final Alias alias;
  const AliasClaimFetchEvent(this.id, this.alias);
}

/// Quand on souhaite accepter ou rejeter une revendication
class AliasClaimRespondEvent extends AliasEvent {
  final String id;
  final Alias alias;
  final AliasRevendication claim;
  final bool decision;
  final List<int>? otpCode;

  const AliasClaimRespondEvent(
    this.id,
    this.alias,
    this.claim,
    this.decision,
    this.otpCode,
  );
}
