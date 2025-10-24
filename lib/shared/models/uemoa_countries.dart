class UEMOACountry {
  final String iso;
  final String name;
  final String phoneCode;
  final String flag;
  final String? iso3;

  /// 8 UEMOA Countries
  /// Used by alias feature (create alias by phone number)
  /// and transfer feature (transfer directly to an account )
  static final List<UEMOACountry> liste = [
    UEMOACountry(
      iso: "BJ",
      iso3: "BEN",
      name: "Benin",
      phoneCode: "+229",
      flag: "🇧🇯",
    ),
    UEMOACountry(
      iso: "BF",
      iso3: "BFA",
      name: "Burkina Faso",
      phoneCode: "+226",
      flag: "🇧🇫",
    ),
    UEMOACountry(
      iso: "CI",
      iso3: "CIV",
      name: "Côte d'Ivoire",
      phoneCode: "+225",
      flag: "🇨🇮",
    ),
    UEMOACountry(
      iso: "GW",
      iso3: "GNB",
      name: "Guinea-Bissau",
      phoneCode: "+245",
      flag: "🇬🇼",
    ),
    UEMOACountry(
      iso: "ML",
      iso3: "MLI",
      name: "Mali",
      phoneCode: "+223",
      flag: "🇲🇱",
    ),
    UEMOACountry(
      iso: "NE",
      iso3: "NER",
      name: "Niger",
      phoneCode: "+227",
      flag: "🇳🇪",
    ),
    UEMOACountry(
      iso: "SN",
      iso3: "SEN",
      name: "Senegal",
      phoneCode: "+221",
      flag: "🇸🇳",
    ),
    UEMOACountry(
      iso: "TG",
      iso3: "TGO",
      name: "Togo",
      phoneCode: "+228",
      flag: "🇹🇬",
    ),
  ];

  /// Fetch UEMOA country details from ISO Code
  static UEMOACountry? get(String iso) {
    return liste.where((element) => element.iso == iso).firstOrNull;
  }

  /// Check if a country is a UEMOA country
  static bool isExist(String iso) {
    for (var el in liste) {
      if (el.iso.toUpperCase() == iso.toUpperCase()) return true;
    }
    return false;
  }

  UEMOACountry({
    required this.iso,
    required this.name,
    required this.phoneCode,
    required this.flag,
    this.iso3,
  });
}
