import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/models/compte_details.dart';
import '../../../ports/input/compte_input_port.dart';
import 'details_event.dart';
import 'details_state.dart';

class CompteDetailsBloc extends Bloc<CompteDetailsEvent, CompteDetailsState> {
  //
  final logger = Logger();

  /// Service
  final CompteInputPort compteInputPort;

  CompteDetailsBloc(
    this.compteInputPort,
  ) : super(CompteDetailsStateInitial()) {
    // Pour recuperer les infos du compte
    on<GetDetailsCompteEvent>(_onGetDetailsCompteEvent);
  }

  /// Récupérer les infos du compte
  void _onGetDetailsCompteEvent(
    GetDetailsCompteEvent event,
    Emitter<CompteDetailsState> emit,
  ) async {
    emit(GetCompteDetailsLoadingState());
    CompteDetails? details = await compteInputPort.getDetails(event.compte);
    emit(details != null
        ? GetCompteDetailsSuccessState(details)
        : GetCompteDetailsErrorState());
  }
}
