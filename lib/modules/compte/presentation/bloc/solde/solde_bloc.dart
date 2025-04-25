import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../ports/input/compte_input_port.dart';
import 'solde_event.dart';
import 'solde_state.dart';

class CompteSoldeBloc extends Bloc<CompteSoldeEvent, CompteSoldeState> {
  //
  final logger = Logger();

  /// Service
  final CompteInputPort compteInputPort;

  CompteSoldeBloc(this.compteInputPort) : super(CompteSoldeStateInitial(null)) {
    // Pour recuperer le solde
    on<GetSoldeCompteEvent>(_onGetSoldeCompteEvent);
  }

  /// Récupérer le solde
  void _onGetSoldeCompteEvent(
    GetSoldeCompteEvent event,
    Emitter<CompteSoldeState> emit,
  ) async {
    try {
      double? solde = await compteInputPort.getSolde(event.compte);
      emit(CompteSoldeDisplayState(solde));
    } //
    catch (e) {
      emit(CompteSoldeErrorState(state.solde, "Erreur"));
      rethrow;
    }
  }
}
