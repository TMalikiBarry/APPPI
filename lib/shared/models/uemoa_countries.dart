class UEMOACountry {
  final String iso;
  final String name;
  final String phoneCode;
  final String flag;

  /// 8 UEMOA Countries
  /// Used by alias feature (create alias by phone number)
  /// and transfer feature (transfer directly to an account )
  static final List<UEMOACountry> liste = [
    UEMOACountry(
      iso: "BJ",
      name: "Benin",
      phoneCode: "+229",
      flag: "🇧🇯",
    ),
    UEMOACountry(
      iso: "BF",
      name: "Burkina Faso",
      phoneCode: "+226",
      flag: "🇧🇫",
    ),
    UEMOACountry(
      iso: "CI",
      name: "Côte d'Ivoire",
      phoneCode: "+225",
      flag: "🇨🇮",
    ),
    UEMOACountry(
      iso: "GW",
      name: "Guinea-Bissau",
      phoneCode: "+245",
      flag: "🇬🇼",
    ),
    UEMOACountry(
      iso: "ML",
      name: "Mali",
      phoneCode: "+223",
      flag: "🇲🇱",
    ),
    UEMOACountry(
      iso: "NE",
      name: "Niger",
      phoneCode: "+227",
      flag: "🇳🇪",
    ),
    UEMOACountry(
      iso: "SN",
      name: "Senegal",
      phoneCode: "+221",
      flag: "🇸🇳",
    ),
    UEMOACountry(
      iso: "TG",
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
  });
}
