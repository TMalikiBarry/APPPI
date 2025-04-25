import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import '../../../domain/models/biometric_method.dart';
import '../../../domain/models/identification_response.dart';
import '../../../domain/models/pin_command.dart';
import '../../../ports/input/identification_input_port.dart';
import 'identification_event.dart';
import 'identification_state.dart';

class IdentificationBloc
    extends Bloc<IdentificationEvent, IdentificationState> {
  //
  final logger = Logger();

  /// Service de gestion des identifications
  final IdentificationInputPort identificationInputPort;

  /// Constructeur Initial
  /// if isCodePinAlreadyCreated == false IdentificationNotConfiguredState
  /// Else IdentificationRequiredState
  IdentificationBloc(this.identificationInputPort)
      : super(IdentificationInitialState([], [])) {
    //
    // Création de code PIN
    on<AskCodePinCreationEvent>(_onAskCodePinCreationEvent);

    // Choix d'un numéro lors de la création du code PIN
    on<PinNumberSelectedEvent>(_onPinNumberSelectedEvent);

    // Configuration de code PIN
    on<SetupCodePinEvent>(_onSetupCodePinEvent);

    // Verification du code PIN
    on<CheckCodePinEvent>(_onCheckCodePinEvent);

    // Pour demander la configuration de la biométrie
    on<AskBiometryConfigurationEvent>(_onAskBiometryConfigurationEvent);

    // Quand l'utilisateur configure la biométrie
    on<SetupBiometryEvent>(_onSetupBiometryEvent);

    // Verification de la biométrie / demande d'authentification par biométrie
    on<CheckBiometryEvent>(_onCheckBiometryEvent);

    // Demander à l'utilisateur de s'identifier
    on<AskIdentificationEvent>(_onAskIdentificationEvent);

    // Demander identification avant une action
    on<AskIdentificationBeforeActionEvent>(
        _onAskIdentificationBeforeActionEvent);

    // Vérifie si le système d'identification est configuré ou pas
    _checkIdentification();
  }

  /// Pour vérifier si l'identification est configurée au démarrage de l'app
  /// Une page de configuration peut s'ouvrir ou de demande d'identification
  void _checkIdentification() async {
    logger.i("checkIdentification bloc");
    bool isCodePinAlreadyCreated = await identificationInputPort.isPinCreated();
    logger.i("isCodePinAlreadyCreated $isCodePinAlreadyCreated");
    // Si le code PIN est déja créé
    if (isCodePinAlreadyCreated) {
      // Vérifier si la biométrie est supportée
      try {
        await _checkBiometryConfiguration();
      } catch (e) {
        logger.e("Erreur d'identification", error: e);
        rethrow;
      }
    }
    // Afficher le formulaire de saisie du code PIN
    else {
      add(const AskCodePinCreationEvent());
    }
  }

  /// vérifie pour l'identification par biométrie
  Future<void> _checkBiometryConfiguration() async {
    // Vérifier si la biométrie est supportée
    bool isBiometryPossible =
        await identificationInputPort.isBiometryPossible();

    // Si la biométrie n'est pas supportée termine le processus d'identification
    if (!isBiometryPossible) {
      add(const AskIdentificationEvent(true, false, []));
    }
    // Si le biométrie est supportée, demander la permission de l'utiliser
    else {
      bool? isBiometryAutorized =
          await identificationInputPort.isBiometryAutorized();
      // si pas encore demandé, affiche demande de configuration
      if (isBiometryAutorized == null) {
        add(const AskBiometryConfigurationEvent());
      }
      // Sinon affiche directement la page d'identification
      else {
        List<BiometricMethod> methods =
            await identificationInputPort.listMethods();
        add(AskIdentificationEvent(true, true, methods));
      }
    }
  }

  /// Pour afficher la page de création de codePIN
  void _onAskCodePinCreationEvent(
    AskCodePinCreationEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    emit(IdentificationNotConfiguredState([], []));
  }

  // Quand on sait un code pin
  void _onPinNumberSelectedEvent(
    PinNumberSelectedEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    // Valeur du code PIN
    PinCommand values = event.pinCode;

    // Vibration effet quand on selectionne un chiffre
    HapticFeedback.selectionClick();

    // S'il veut effacer
    if (event.digit == -1) {
      values.value.removeLast();
      emit(IdentificationNotConfiguredState(values.value, []));
      return;
    }

    // positionner le chiffre selePidectionné
    if (values.value.length < event.position) {
      values.value[event.position] = event.digit;
    } else {
      values.value.add(event.digit);
    }
    emit(IdentificationNotConfiguredState(values.value, []));
    // Si c'est valide, envoie demande de création
    if (values.isValid()) {
      add(SetupCodePinEvent(values));
    }
  }

  /// Quand on crée un code PIN
  void _onSetupCodePinEvent(
    SetupCodePinEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    try {
      await identificationInputPort.setupCodePin(event.pinCode);
      // Vérifier la configuration de la biométrie
      await _checkBiometryConfiguration();
    } // emit error event
    catch (e) {
      //
    }
  }

  /// Pour afficher la page de configuration de la biométrie
  void _onAskBiometryConfigurationEvent(
    AskBiometryConfigurationEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    // liste les méthodes
    List<BiometricMethod> methods = await identificationInputPort.listMethods();
    if (methods.isEmpty) {
      emit(IdentificationRequiredState([], methods));
    } //
    else {
      // Afficher la vue de configuration de la biométrie
      emit(BiometryNotConfiguredState([], methods));
    }
  }

  /// Quand l'utilisateur configure la biométrie pour autoriser son utilisation
  /// toute suite ou pas maintenant
  void _onSetupBiometryEvent(
    SetupBiometryEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    try {
      // Si la liste des methodes est vide
      // => l'utilisateur n'a pas marqué son accord
      await identificationInputPort.setupBiometry(
          event.methods.isNotEmpty, event.methods);
      add(AskIdentificationEvent(true, true, event.methods));
    } // emit error event
    catch (e) {
      //
    }
  }

  /// Pour afficher la page de saisie par code PIN
  void _onAskIdentificationEvent(
    AskIdentificationEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    // identification requise
    emit(IdentificationRequiredState([], event.methods));
    // Si l'identification par biométrie est configurée, demander
    if (event.methods.isNotEmpty) {
      IdentificationResponse response =
          await identificationInputPort.identifyUsingBiometric();
      if (response.passed) {
        emit(IdentificationSuccessState(
          [],
          event.methods,
          response.method!
              .toString()
              .split(".")[1], //"IdentificationResponseMethod.pin"
        ));
      }
    }
  }

  /// Pour afficher la pagne de saie par code PIN
  void _onCheckBiometryEvent(
    CheckBiometryEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    // Si l'identification par biométrie est configurée, demander
    IdentificationResponse response =
        await identificationInputPort.identifyUsingBiometric();
    if (response.passed) {
      emit(IdentificationSuccessState(
        [],
        event.methods,
        response.method!.toString().split(".")[1],
      ));
    }
  }

  /// Quand on vérifie un code PIN
  void _onCheckCodePinEvent(
    CheckCodePinEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    try {
      // valeur actuelle du code PIN
      PinCommand values = event.pinCode;

      // Vibration effet quand on selectionne un chiffre
      HapticFeedback.selectionClick();

      // S'il veut effacer
      if (event.digit == -1) {
        values.value.removeLast();
        emit(IdentificationRequiredState(values.value, event.methods));
        return;
      }

      // positionner le chiffre selectionné
      if (values.value.length < event.position) {
        values.value[event.position] = event.digit;
      } else {
        values.value.add(event.digit);
      }

      // Si c'est valide, envoie demande de création
      if (values.isValid()) {
        IdentificationResponse response =
            await identificationInputPort.identifyUsingCodePin(event.pinCode);
        if (response.passed) {
          // emit(IdentificationSuccessState(event.pinCode.value));
          emit(IdentificationSuccessState(
            event.pinCode.value,
            event.methods,
            response.method!.toString().split(".")[1],
          ));
        } else {
          emit(IdentificationErrorState(
            event.pinCode.value,
            event.methods,
            IdentificationResponseError.pinIncorrect,
          ));
        }
      } else {
        emit(IdentificationRequiredState(values.value, event.methods));
      }
    } catch (e) {
      throw Exception("Erreur de connexion avec le code PIN $e");
    }
  }

  // Demander autorisation avant de faire uen action
  void _onAskIdentificationBeforeActionEvent(
    AskIdentificationBeforeActionEvent event,
    Emitter<IdentificationState> emit,
  ) async {
    if (state.methods.isNotEmpty) {
      // Si l'identification par biométrie est configurée, demander
      IdentificationResponse response =
          await identificationInputPort.identifyUsingBiometric();
      if (response.passed) {
        emit(IdentificationSuccessState(
          [],
          state.methods,
          response.method!.toString().split(".")[1],
        ));
      } else {
        emit(IdentificationRequiredState([], state.methods));
      }
    } else {
      emit(IdentificationRequiredState([], state.methods));
    }
  }
}
