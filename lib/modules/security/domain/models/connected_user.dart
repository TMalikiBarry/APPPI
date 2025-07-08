class ConnectedUser {
  //
  final String id;
  //
  final String username;
  //
  final String firstName;
  //
  final String lastName;
  //
  final String country;
  //
  final String address;
  //
  final String telephone;
  //
  final String? email;
  //
  final String? avatar;

  static ConnectedUser? current;

  //
  final String? alias;

  ConnectedUser({
    //
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.address,
    required this.telephone,
    this.email,
    this.avatar, //
    this.alias, //
  });

  // Retourne le nom complet de l'utilisateur
  String nomComplet() => "$firstName $lastName";

  /// Retourne les initiales de l'utilisateur sur deux caractères
  String initiales() => "${firstName[0]}${lastName[0]}";

  // Reference client /  Numéro de compte du client
  String reference() => username;

  // Reference client /  Numéro de compte du client
  String? paymentAddress() => alias;

  /// Convertit du JSON en objet ConnectedUser
  static ConnectedUser fromJson(Map<String, dynamic> json) {
    return ConnectedUser(
      id: json['sub'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      country: json['country'] as String,
      address: json['address'] as String,
      telephone: json['telephone'] as String,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      alias: json['alias'] as String?,
    );
  }

  /// Convertit un objet ConnectedUser en JSON
  Map<String, dynamic> toJson(ConnectedUser instance) {
    return {
      'sub': instance.id,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'country': instance.country,
      'address': instance.address,
      'telephone': instance.telephone,
      'email': instance.email,
      'avatar': instance.avatar,
    };
  }
}
