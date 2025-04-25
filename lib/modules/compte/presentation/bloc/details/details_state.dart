import '../../../domain/models/compte_details.dart';

abstract class CompteDetailsState {}

/// Etat initial du widget
class CompteDetailsStateInitial extends CompteDetailsState {}

class GetCompteDetailsLoadingState extends CompteDetailsState {
  GetCompteDetailsLoadingState();
}

/// Etat du widget lorque le compte est recuperé
class GetCompteDetailsSuccessState extends CompteDetailsState {
  final CompteDetails compteDetails;
  GetCompteDetailsSuccessState(this.compteDetails);
}

/// Etat lorsqu'il y a une erreur pendant la récupération des infos du compte
class GetCompteDetailsErrorState extends CompteDetailsState {
  GetCompteDetailsErrorState();
}
