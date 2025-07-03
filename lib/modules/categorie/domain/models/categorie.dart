import '../../../../core/assets.dart';

enum CategorieIconType { asset, emoji, photo }

class Categorie {
  ///
  Categorie({
    required this.id,
    required this.label,
    required this.icon,
    this.bgColor,
    this.iconType,
  });
  late String id;
  late String label;
  late String icon;
  late CategorieIconType? iconType;
  late int? bgColor;

  Categorie.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    label = json['label'];
    icon = json['icon'];
    bgColor = json['bgColor'];
    iconType = json['iconType'] != null
        ? json['iconType'] == 'asset'
            ? CategorieIconType.asset
            : json['iconType'] == 'emoji'
                ? CategorieIconType.emoji
                : CategorieIconType.photo
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['icon'] = icon;
    data['bgColor'] = bgColor;
    data['iconType'] = iconType?.toString();
    return data;
  }

  /// Default
  static Categorie defaultCategorie = Categorie(
    id: "TRANSFER",
    label: "Transfert",
    icon: Images.iconsTransfert,
    bgColor: 0xFFF2C374,
  );

  /// Prédéfinis
  static List<Categorie> defaultListe = [
    Categorie(
      id: "FACTURES",
      label: "Factures",
      icon: Images.iconsFacture,
      bgColor: 0xFFEDB37E,
    ),
    Categorie(
      id: "CASH",
      label: "Cash",
      icon: Images.iconsCash,
      bgColor: 0xFFAFCCA1,
    ),
    Categorie(
      id: "RESTAURANTS",
      label: "Restaurants",
      icon: Images.iconsRestaurant,
      bgColor: 0xFF92B0EA,
    ),
    Categorie(
      id: "SHOPPING",
      label: "Shopping",
      icon: Images.iconsShopping,
      bgColor: 0xFF95A3D3,
    ),
    Categorie(
      id: "LOISIRS",
      label: "Loisirs",
      icon: Images.iconsLoisir,
      bgColor: 0xFF9DDDD5,
    ),
    Categorie(
      id: "ALIMENTATION",
      label: "Alimentation",
      icon: Images.iconsAlimentation,
      bgColor: 0xFFFC8D94,
    ),
    Categorie(
      id: "SANTE",
      label: "Santé",
      icon: Images.iconsSante,
      bgColor: 0xFFF2A9CE,
    ),
    Categorie(
      id: "LOGEMENT",
      label: "Logement",
      icon: Images.iconsLogement,
      bgColor: 0xFFF09EBC,
    ),
    Categorie(
      id: "TRANSFER",
      label: "Transferts",
      icon: Images.iconsTransfert,
      bgColor: 0xFFF2C374,
    ),
    Categorie(
      id: "TRANSACTIONS",
      label: "Transactions",
      icon: Images.iconsTransaction,
      bgColor: 0xFF79A6FC,
    ),
    Categorie(
      id: "SOINS_PERSONNELS",
      label: "Soins personnels",
      icon: Images.iconsSoinspersonnel,
      bgColor: 0xFFA3B6DA,
    ),
    Categorie(
      id: "BUDGET",
      label: "Budget",
      icon: Images.iconsBudget,
      bgColor: 0xFF9ACED9,
    ),
    Categorie(
      id: "ECONOMIES",
      label: "Economies",
      icon: Images.iconsEconomie,
      bgColor: 0xFFD3A7DA,
    ),
    Categorie(
      id: "TRANSPORTS",
      label: "Transports",
      icon: Images.iconsTransport,
      bgColor: 0xFFFFAA99,
    ),
    Categorie(
      id: "VOYAGE",
      label: "Voyage",
      icon: Images.iconsVoyage,
      bgColor: 0xFFC8AD98,
    ),
    Categorie(
      id: "DEPENSES_RELIGIEUSES",
      label: "Dépenses religieuses",
      icon: Images.iconsDepensereligieuse,
      bgColor: 0xFFEDB37E,
    ),
    Categorie(
      id: "DONS",
      label: "Dons",
      icon: Images.iconsDon,
      bgColor: 0xFFFFAA99,
    ),
    Categorie(
      id: "EDUCATION",
      label: "Education",
      icon: Images.iconsEducation,
      bgColor: 0xFFAFCCA1,
    ),
    Categorie(
      id: "AUTRES",
      label: "Autres",
      icon: Images.iconsAutre,
      bgColor: 0xFFCDD0CD,
    ),
  ];

  /// Suggested for creation
  static List<Categorie> suggested = [
    Categorie(
      id: "SPORTS",
      label: "Sports",
      icon: Images.iconsSport,
      bgColor: 0xFFAFCCA1,
    ),
    Categorie(
      id: "CAFE",
      label: "Café",
      icon: Images.iconsCafe,
      bgColor: 0xFFD3A7DA,
    ),
    Categorie(
      id: "CADEAUX",
      label: "Cadeaux",
      icon: Images.iconsCadeau,
      bgColor: 0xFFF2A9CE,
    ),
    Categorie(
      id: "DONATION",
      label: "Dons",
      icon: Images.iconsDonation,
      bgColor: 0xFF9DDDD5,
    ),
    Categorie(
      id: "BEAUTE",
      label: "Beaute",
      icon: Images.iconsBeaute,
      bgColor: 0xFFFFAA99,
    ),
    Categorie(
      id: "BOISSONS",
      label: "Boissons",
      icon: Images.iconsBoissons,
      bgColor: 0xFFA3B6DA,
    ),
  ];
}
