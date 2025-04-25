import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/models/connected_user.dart';
import '../../../domain/models/connexion_response.dart';
import '../../../domain/models/login_command.dart';
import '../../../ports/input/connexion_input_port.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //
  final logger = Logger();

  /// Service de gestion des identifications
  final ConnexionInputPort connexionInputPort;

  /// ConfigLoadingState est l'état initial de l'app en cours de chargement
  LoginBloc(this.connexionInputPort)
      : super(LoginFormState(LoginCommand(), false)) {
    //
    on<FormChangedEvent>(_onFormChangedEvent);
    //
    on<PasswordToggledEvent>(_onPasswordToggledEvent);
    //
    on<ConnexionEvent>(_onConnexion);
    //
    on<DeconnexionEvent>(_onDeconnexion);
    // Check if user is connected
    on<CheckSessionEvent>(_onCheckSessionEvent);
  }

  ConnectedUser? getConnectedUser() {
    return state is LoginSuccessState
        ? (state as LoginSuccessState).user!
        : null;
  }

  void _onPasswordToggledEvent(
    PasswordToggledEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginFormState(event.values, !event.toggle));
  }

  /// Quand le form change et qu'une validation est demandée
  void _onFormChangedEvent(
      FormChangedEvent event, Emitter<LoginState> emit) async {
    //
    LoginCommand form = event.values;
    form.isValid();
    emit(LoginFormState(form, event.passwordVisible));
  }

  void _onConnexion(ConnexionEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState(event.loginData, false));
      ConnexionResponse response =
          await connexionInputPort.login(event.loginData);
      if (response.user != null) {
        emit(LoginSuccessState(event.loginData, false, response.user!));
      }
    } //
    catch (e) {
      //
    }
  }

  void _onDeconnexion(
    DeconnexionEvent event,
    Emitter<LoginState> emit,
  ) async {
    await connexionInputPort.logout();
    emit(LoginFormState(LoginCommand(), false));
  }

  void _onCheckSessionEvent(
    CheckSessionEvent event,
    Emitter<LoginState> emit,
  ) async {
    ConnectedUser? response = await connexionInputPort.loadConnectedUser();
    if (response != null) {
      emit(LoginSuccessState(LoginCommand(), false, response));
    } //
    else {
      emit(LoginErrorState(
        state.values,
        state.passwordVisible,
        "not-connected",
      ));
    }
  }
}
