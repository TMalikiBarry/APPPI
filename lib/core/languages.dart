import 'dart:ui';

enum Languages {
  //
  fr("fr_FR", "Français"),
  en("en_EN", "English"),
  pt("pt_PT", "Portuguese");

  // Codification du theme
  final String code;
  final String label;

  const Languages(this.code, this.label);

  static List<Languages> list() => Languages.values;

  static Iterable<Locale> supportedLocales() =>
      Languages.values.map<Locale>((e) => Locale(e.name));

  static Languages? fromCode(String code) {
    try {
      return Languages.values.firstWhere(
        (lang) => lang.code == code,
      );
    } catch (e) {
      return null;
    }
  }
}

// class Language {
//   /// Locale de l'utilisateur en fonction de la langue
//   static Locale get(String? code) {
//     //
//     if (code == Languages.fr.code) {
//       return Locale(Languages.fr.name);
//     }
//     //
//     else if (code == Languages.en.code) {
//       return Locale(Languages.en.name);
//     }
//     //
//     else if (code == Languages.pt.code) {
//       return Locale(Languages.pt.name);
//     }
//     //
//     else {
//       Locale locale = PlatformDispatcher.instance.locale;
//       if (['fr', 'en', 'pt'].contains(locale.languageCode)) {
//         return locale;
//       }
//       return Locale(Languages.fr.name);
//     }
//   }
// }
