import 'package:permission_handler/permission_handler.dart';

import '../domain/exceptions/permission_exception.dart';
import '../domain/models/permission_type.dart';
import '../ports/output/permission_output_port.dart';

class PermissionOutputLocal implements PermissionOutputPort {
  //
  PermissionOutputLocal();

  @override
  Future<bool> isPermissionGranted(PermissionType permission) async {
    switch (permission) {
      case PermissionType.contact:
        return !(await Permission.contacts.isDenied);
      case PermissionType.notification:
        return !(await Permission.notification.isDenied);
      case PermissionType.localisationGPS:
        return !(await Permission.location.status.isDenied);
    }
  }

  @override
  Future<bool> grantPermission(PermissionType permission) async {
    Permission permissionSystem;
    switch (permission) {
      case PermissionType.contact:
        permissionSystem = Permission.contacts;
      case PermissionType.notification:
        permissionSystem = Permission.notification;
      case PermissionType.localisationGPS:
        permissionSystem = Permission.location;
    }
    // If permanently denied, ask user to open app settings
    bool isPermanentlyDenied = await permissionSystem.isPermanentlyDenied;
    if (isPermanentlyDenied) {
      await openAppSettings();
    }
    // Grant status
    PermissionStatus grantStatus = await permissionSystem.request();
    return grantStatus == PermissionStatus.granted;
  }

  @override
  Future<bool> isPermissionServiceEnabled(PermissionType permission) async {
    switch (permission) {
      case PermissionType.localisationGPS:
        return (await Permission.location.serviceStatus.isEnabled);
      default:
        throw UnknowPermissionException(permission);
    }
  }
}
