import '../../../domain/models/permission_type.dart';

abstract class PermissionEvent {
  const PermissionEvent();
}

/// Quand on veut demander l'acceptation d'une permission
// class AskPermissionEvent extends PermissionEvent {
//   //
//   const AskPermissionEvent(this.permission);
//   final PermissionType permission;
// }

/// Quand l'utilisateur accepte maintenant ou pas la permission
class AcceptPermissionEvent extends PermissionEvent {
  //
  const AcceptPermissionEvent(this.permission, this.acceptation);
  final PermissionType permission;
  final bool acceptation;
}

/// Quand on a fini sur la vue permissions
class FinishPermissionEvent extends PermissionEvent {
  //
  const FinishPermissionEvent();
}
