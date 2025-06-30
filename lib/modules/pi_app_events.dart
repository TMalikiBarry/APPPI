import 'package:micro_core/micro_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// * Micro App Events
/// Register the micro app events here
/// so we provide them in [RouteEvents] to be fired from accross the micro apps.
/// The [initRouteListeners] method above will listen to the events listened here.
///

class BceaoPiAppEvent extends RouteEvent {
  final String user;
  SharedPreferences? prefs;
  BceaoPiAppEvent(this.user, this.prefs);
}

///
/// Exports the events in a class so we dont need to import
/// them from other micro apps. LoginEvents will be used by [RouteEvents]
///
class BceaoPIEvents extends RouteEvent {
  RouteEvent userTFSBceaoPIEvent(String user, SharedPreferences prefs) => BceaoPiAppEvent(user, prefs);
}