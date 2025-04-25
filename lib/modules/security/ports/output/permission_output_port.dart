import '../../domain/models/permission_type.dart';

abstract class PermissionOutputPort {
  //
  /// Pour vérifier si l'utilisateur a accordé la permission
  Future<bool> isPermissionGranted(PermissionType permission);

  /// Pour notifier l'accord d'une permission
  Future<bool> grantPermission(PermissionType permission);

  /// Pour vérifier si un service qu'on veut utiliser est activé
  Future<bool> isPermissionServiceEnabled(PermissionType permission);
}
