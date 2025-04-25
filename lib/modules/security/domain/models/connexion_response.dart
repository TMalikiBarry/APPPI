import 'connected_user.dart';

class ConnexionResponse {
  String? challenge;
  ConnectedUser? user;

  ConnexionResponse({this.user, this.challenge});
}
