abstract class CompteDetailsEvent {
  const CompteDetailsEvent();
}

/// Evenement permettant de recuperer les informations d'un compte
class GetDetailsCompteEvent extends CompteDetailsEvent {
  String compte;
  GetDetailsCompteEvent(this.compte);
}
