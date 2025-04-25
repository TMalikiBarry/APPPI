abstract class CompteSoldeEvent {
  const CompteSoldeEvent();
}

/// Evenement permettant de recuperer le solde d'un compte
class GetSoldeCompteEvent extends CompteSoldeEvent {
  String compte;
  GetSoldeCompteEvent(this.compte);
}

/// Evenement permettant d'afficher / cacher le solde et tous les autres montants affichés dans l'app
class AfficherCacherMontantEvent extends CompteSoldeEvent {
  AfficherCacherMontantEvent();
}

/// Evenement permettant d'afficher / cacher le montant du solde
class ToggleSoldeDisplayEvent extends CompteSoldeEvent {
  final bool display;
  ToggleSoldeDisplayEvent(this.display);
}

/// Evenement permettant d'afficher / cacher l'oeil
class ToggleEyeDisplayEvent extends CompteSoldeEvent {
  final bool display;
  ToggleEyeDisplayEvent(this.display);
}
