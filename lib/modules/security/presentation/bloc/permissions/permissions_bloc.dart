import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../core/notifications.dart';
import '../../../../config/adapters/ui/bloc/config_bloc.dart';
import '../../../domain/models/permission_type.dart';
import '../../../ports/input/permission_input_port.dart';
import 'permissions_event.dart';
import 'permissions_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  //
  final logger = Logger();

  // Service de gestion des identifications
  final PermissionInputPort permissionInputPort;

  // Bloc de gestion de la configuration
  final ConfigBloc configBloc;

  // Bloc de gestion de la configuration
  final PermissionType permission;

  static final String errorUnknown = "UNKNOWN";

  /// Constructeur
  PermissionBloc(this.permissionInputPort, this.configBloc, this.permission)
      : super(PermissionInitialState(permission)) //
  {
    // Demande de permission
    //on<AskPermissionEvent>(_onAskPermissionEvent);

    // Acceptation de permission
    on<AcceptPermissionEvent>(_onAcceptPermissionEvent);

    // Terminer la demande d'autorisation des permissions
    on<FinishPermissionEvent>(_onFinishPermissionEvent);
  }

  void _onAcceptPermissionEvent(
      AcceptPermissionEvent event, Emitter<PermissionState> emit) async {
    String name = event.permission.name.toUpperCase();

    // Demander réellement la permission si accepté
    if (event.acceptation) {
      bool granted =
          await permissionInputPort.grantPermission(event.permission);
      if (granted) {
        emit(PermissionGrantedState(event.permission));
        if (event.permission == PermissionType.notification) {
          try {
            await AppNotifications.configure();
          } //
          catch (e) {
            if (e is NotificationException) {
              // Gérer l'exception spécifique ici
              logger.i("NotificationException: ${e.name}");
              emit(PermissionErrorState(event.permission, e.name));
              return;
            } else {
              logger.e("Erreur imprévue configuration FCM", error: e);
              emit(PermissionErrorState(
                  event.permission, PermissionBloc.errorUnknown));
            }
          }
        }
        // Configuration - la permission a été acceptée
        await configBloc.configInputPort.modifier("PERMISSION_$name", "1");
      } else {
        // Pour notification on force l'acceptation sinon on avance pas
        if (event.permission == PermissionType.notification) {
          return;
        }
        // Configuration - la permission a été refusée
        await configBloc.configInputPort.modifier("PERMISSION_$name", "0");
      }
    } else {
      // Configuration - la permission a été refusée
      await configBloc.configInputPort.modifier("PERMISSION_$name", "0");
    }

    // Apres avoir demandé pour notification, demander pour contact
    if (event.permission == PermissionType.notification) {
      emit(PermissionInitialState(PermissionType.contact));
    } else {
      emit(PermissionFinalState());
    }
  }

  void _onFinishPermissionEvent(
      FinishPermissionEvent event, Emitter<PermissionState> emit) {
    emit(PermissionFinalState());
  }
}
