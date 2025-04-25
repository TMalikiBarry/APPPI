abstract class IdentificationPinOutputPort {
  //
  /// Pour vérifier si l'utilisateur a déjà créé un code PIN
  Future<bool> isPinCreated();

  /// Cette fonctionnalité pemet de créer un code pin de connexion
  Future<void> createPin(String codePin);

  /// Cette fonctionnalité pemet de vérifier un code pin de connexion
  Future<bool> checkPin(String codePin);
}
