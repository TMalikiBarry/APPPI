abstract class CompteSoldeState {
  final double? solde;
  const CompteSoldeState(this.solde);
}

/// Etat initial du widget qui gère le solde
class CompteSoldeStateInitial extends CompteSoldeState {
  CompteSoldeStateInitial(super.solde);
}

/// Etat initial du widget qui gère le solde
class CompteSoldeDisplayState extends CompteSoldeState {
  CompteSoldeDisplayState(super.solde);
}

/// Etat lorsqu'il y a une erreur pendant la récupération du solde
class CompteSoldeErrorState extends CompteSoldeState {
  final String error;

  CompteSoldeErrorState(super.solde, this.error);
}
