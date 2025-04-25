import '../../domain/models/permission_type.dart';

abstract class PermissionInputPort {
  //
  /// Pour vérifier si l'utilisateur a accordé la permission
  Future<bool> isPermissionGranted(PermissionType permission);

  /// Pour notifier l'accord d'une permission
  Future<bool> grantPermission(PermissionType permission);

  /// Pour vérifier si un service est activé avant de demander l'accès
  Future<bool> isPermissionServiceEnabled(PermissionType permission);
}
