import '../models/permission_type.dart';
import '../../ports/input/permission_input_port.dart';
import '../../ports/output/permission_output_port.dart';

class PermissionService implements PermissionInputPort {
  //
  final PermissionOutputPort permissionOutputPort;

  //
  const PermissionService(this.permissionOutputPort);

  @override
  Future<bool> grantPermission(PermissionType permission) async {
    return await permissionOutputPort.grantPermission(permission);
  }

  @override
  Future<bool> isPermissionGranted(PermissionType permission) async {
    return await permissionOutputPort.isPermissionGranted(permission);
  }

  @override
  Future<bool> isPermissionServiceEnabled(PermissionType permission) async {
    return await permissionOutputPort.isPermissionServiceEnabled(permission);
  }
}
