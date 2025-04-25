import '../models/permission_type.dart';

class UnknowPermissionException implements Exception {
  //
  final PermissionType permission;
  final Object? exception;

  ///
  UnknowPermissionException(this.permission, [this.exception]);

  @override
  String toString() => '$permission <- $exception';
}
