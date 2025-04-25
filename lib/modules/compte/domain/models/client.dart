class Client {
  Client({
    required this.nom,
    required this.categorie,
    required this.nationalite,
    required this.paysResidence,
    required this.telephone,
    required this.genre,
    required this.identificationNationale,
    this.email,
    this.adresse,
    this.codePostale,
    this.dateNaissance,
    this.paysNaissance,
    this.villeNaissance,
    this.nomMere,
    this.photo,
    this.numeroPasseport,
  });
  late String nom;
  late String categorie;
  late String nationalite;
  late String paysResidence;
  late String telephone;
  late String genre;
  late String identificationNationale;
  String? email;
  String? adresse;
  String? codePostale;
  String? dateNaissance;
  String? paysNaissance;
  String? villeNaissance;
  String? nomMere;
  String? photo;
  String? numeroPasseport;

  Client.fromJson(Map<dynamic, dynamic> json) {
    nom = json['nom'];
    categorie = json['categorie'];
    nationalite = json['nationalite'];
    paysResidence = json['paysResidence'];
    telephone = json['telephone'];
    genre = json['genre'];
    identificationNationale = json['identificationNationale'];
    email = json.containsKey('email') ? json['email'] : null;
    adresse = json.containsKey('adresse') ? json['adresse'] : null;
    codePostale = json.containsKey('codePostale') ? json['codePostale'] : null;
    dateNaissance =
        json.containsKey('dateNaissance') ? json['dateNaissance'] : null;
    paysNaissance =
        json.containsKey('paysNaissance') ? json['paysNaissance'] : null;
    villeNaissance =
        json.containsKey('villeNaissance') ? json['villeNaissance'] : null;
    nomMere = json.containsKey('nomMere') ? json['nomMere'] : null;
    photo = json.containsKey('photo') ? json['photo'] : null;
    numeroPasseport =
        json.containsKey('numeroPasseport') ? json['numeroPasseport'] : null;
  }

  Map<dynamic, dynamic> toJson() {
    Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['nom'] = nom;
    data['categorie'] = categorie;
    data['nationalite'] = nationalite;
    data['paysResidence'] = paysResidence;
    data['telephone'] = telephone;
    data['genre'] = genre;
    data['identificationNationale'] = identificationNationale;
    if (email != null) data['email'] = email;
    if (adresse != null) data['adresse'] = adresse;
    if (codePostale != null) data['codePostale'] = codePostale;
    if (dateNaissance != null) data['dateNaissance'] = dateNaissance;
    if (paysNaissance != null) data['paysNaissance'] = paysNaissance;
    if (villeNaissance != null) data['villeNaissance'] = villeNaissance;
    if (nomMere != null) data['nomMere'] = nomMere;
    if (photo != null) data['photo'] = photo;
    if (numeroPasseport != null) data['numeroPasseport'] = numeroPasseport;
    return data;
  }
}
