import '../../domain/models/alias.dart';
import '../../domain/models/alias_create_command.dart';
import '../../domain/models/alias_error.dart';
import '../../domain/models/alias_revendication.dart';

abstract class AliasState {
  const AliasState();
}

class AliasInitialState extends AliasState {
  const AliasInitialState();
}

/// Etat quand on a pu vérifier l'existance de l'alias
class AliasVerifExistState extends AliasState {
  //
  const AliasVerifExistState(this.alias);

  final Alias alias;
}

/// Etat quand on a pu recupérer l'alias
class AliasExistState extends AliasState {
  //
  const AliasExistState(this.alias, [this.claim]);

  final Alias alias;
  // revendication sur cet alias
  final AliasRevendication? claim;
}

/// Pendant que l'on recupére l'alias'
final class AliasLoadingState extends AliasState {
  AliasLoadingState();
}

/// Etat quand l'alias n'existe pas
class AliasNotExistState extends AliasState {}

/// Etat quand on initie la creation d'un alias
class AliasCreatingState extends AliasState {
  //
  final AliasCreateCommand values;

  AliasCreatingState(this.values);
}

/// Etat quand la creation d'un alias à échouée
class AliasFetchErrorState extends AliasState {
  //
  final String compte;
  // Erreur
  final AliasError? error;

  AliasFetchErrorState(this.compte, this.error);
}

/// Etat quand la creation d'un alias à reussie
class AliasCreationSuccessState extends AliasState {}

/// Etat quand la creation d'un alias à échouée
class AliasCreationErrorState extends AliasState {
  //
  final AliasCreateCommand values;
  // Erreur
  final AliasError? error;

  AliasCreationErrorState(this.error, this.values);
}

/// Etat quand on est entrain de créer un alias de type MBNO
class AliasMBNOCreationState extends AliasState {
  final AliasCreateCommand values;

  AliasMBNOCreationState(this.values);
}

/// Etat quand on lance l'envoi du code pin
class AliasMBNOVerificationState extends AliasState {
  //
  final AliasCreateCommand values;
  // Code PIN
  final List<int> otpCode;
  // Erreur
  final AliasError? error;

  AliasMBNOVerificationState(this.values, this.otpCode, this.error);
}

/// Etat quand initie la vérification du code otp
class AliasMBNOVerificationLoadingState extends AliasState {}

/// Etat quand on initie la suppression d'un alias
class AliasDeletingState extends AliasState {
  AliasDeletingState();
}

/// Etat quand la suppression d'un alias à échouée
class AliasDeleteErrorState extends AliasState {
  //
  final String error;

  AliasDeleteErrorState(this.error);
}

/// Etat quand on est entrain d'envoyer la demande de revendication
class AliasClaimAskingState extends AliasState {
  AliasClaimAskingState();
}

/// Etat quand la demande de revendication est envoyée avec succès
class AliasClaimAskingSuccessState extends AliasState {
  AliasClaimAskingSuccessState();
}

/// Etat quand la demande de revendication n'est pas envoyée avec succès
class AliasClaimAskingErrorState extends AliasState {
  //
  final AliasCreateCommandPhoneNumber phoneNumber;
  // Erreur
  final AliasError? error;

  AliasClaimAskingErrorState(this.error, this.phoneNumber);
}

/// Etat quand on recherche une demande de revendication
class AliasClaimFetchingState extends AliasState {
  //
  final String id;
  final Alias alias;
  AliasClaimFetchingState(this.id, this.alias);
}

/// Etat quand on traite une demande de revendication
class AliasClaimHandlingState extends AliasState {
  //
  final String id;
  final Alias alias;
  final AliasRevendication claim;
  final bool rejecting;
  AliasClaimHandlingState(this.id, this.alias, this.claim, this.rejecting);
}

/// Etat quand on trouve pas une demande de revendication
class AliasClaimNotFoundState extends AliasState {
  //
  final String id;
  final Alias alias;

  AliasClaimNotFoundState(this.id, this.alias);
}

class AliasClaimHandlingErrorState extends AliasState {
  final String id;
  final Alias alias;
  final AliasRevendication claim;
  // Il est entrain de rejeter la demande
  final bool rejecting;
  // Erreur
  final AliasError? error;

  AliasClaimHandlingErrorState(
    this.id,
    this.alias,
    this.claim,
    this.rejecting,
    this.error,
  );
}

/// Etat quand la demande de revendication est acceptée ou rejetée avec succès
class AliasClaimHandlingSuccessState extends AliasState {
  final String id;
  final Alias alias;
  final AliasRevendication claim;
  AliasClaimHandlingSuccessState(this.id, this.alias, this.claim);
}
