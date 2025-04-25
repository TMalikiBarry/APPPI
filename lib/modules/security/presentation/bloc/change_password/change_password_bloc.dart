import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../domain/models/change_password_command.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  //
  final logger = Logger();

  final String username;

  /// ConfigLoadingState est l'état initial de l'app en cours de chargement
  ChangePasswordBloc(this.username)
      : super(ChangePasswordFormState(
            ChangePasswordCommand(username: username), false)) {
    // Show / hide password
    on<PasswordToggledEvent>(_onPasswordToggledEvent);
    //
    on<FormChangedEvent>(_onFormChangedEvent);
    //
    on<SendPasswordEvent>(_onSendPasswordEvent);
  }

  // Quab l'utilsateur veut afficher/cacher le mot de passe à la saisie
  void _onPasswordToggledEvent(
      PasswordToggledEvent event, Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordFormState(event.values, !event.toggle));
  }

  /// Quand le form change et qu'une validation est demandée
  void _onFormChangedEvent(
      FormChangedEvent event, Emitter<ChangePasswordState> emit) async {
    //
    ChangePasswordCommand form = event.values;
    form.isValid();
    emit(ChangePasswordFormState(form, event.passwordVisible));
  }

  void _onSendPasswordEvent(
      SendPasswordEvent event, Emitter<ChangePasswordState> emit) async {
    try {
      emit(ChangePasswordLoadingState(event.changePasswordData, false));
      await Future.delayed(const Duration(seconds: 2), () {
        //  Simulation succés
        emit(ChangePasswordSuccessState(event.changePasswordData, false));
      });
    } //
    catch (e) {
      logger.e('Erreur lors du changement de mot de passe', error: e);
      emit(ChangePasswordErrorState(
          event.changePasswordData, false, e.toString()));
    }
  }
}
