import '../../../domain/models/permission_type.dart';

abstract class PermissionState {
  const PermissionState();
}

/// Etat initial
final class PermissionInitialState extends PermissionState {
  PermissionInitialState(this.permission);
  final PermissionType permission;
}

/// Etat final
final class PermissionFinalState extends PermissionState {
  PermissionFinalState();
}

final class PermissionGrantedState extends PermissionState {
  PermissionGrantedState(this.permission);
  final PermissionType permission;
}

final class PermissionErrorState extends PermissionState {
  final PermissionType permission;
  final String errorCode;
  PermissionErrorState(this.permission, this.errorCode);
}
