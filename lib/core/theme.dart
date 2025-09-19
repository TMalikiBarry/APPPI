import 'dart:ui';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

enum Themes {
  //
  system("System"),
  light("lightTheme"),
  dark("darkTheme"),
  yellow("yellowTheme"),
  green("greenTheme"),
  blue("blueTheme");

  // Codification du theme
  final String code;

  const Themes(this.code);

  static Themes fromCode(String code) {
    try {
      return Themes.values.firstWhere((e) => e.code == code);
    } catch (e) {
      return Themes.light;
    }
  }

  static List<Themes> list() => Themes.values;

  String label(AppLocalizations traductions) {
    if (this == Themes.light) {
      return traductions.appSettingPageMenuThemeLight;
    }
    //
    else if (this == Themes.dark) {
      return traductions.appSettingPageMenuThemeDark;
    }
    return traductions.appSettingPageMenuThemeDefault;
  }
}

class Themer {
  //
  /// private constructor which prevents the class from being instantiated.
  Themer._();

  /// Couleur marron
  static const Color whiteColor = Color(0xFFffffff);

  /// Couleur noire
  static const Color blackColor = Color(0xFF000000);

  /// Couleur marron
  static const Color brownColor = Color(0xFF282C5D);

  /// Couleur jaune
  static const Color amberColor = Color(0xFFA81735);

  /// Couleur neural 01
  static const Color neural01Color = Color(0xFFE6E4E2);

  /// Couleur neural 02
  static const Color neural02Color = Color(0xFFBDBDBB);

  /// Couleur neural 03
  static const Color neural03Color = Color(0xFF8B887E);

  /// Couleur neural 04
  static const Color neural04Color = Color(0xFF615D52);

  /// Couleur neural 05
  static const Color neural05Color = Color(0xFF5C5451);

  // Primary
  static const Color primary = Color(0xFFA81735);

  /// Primary Light
  static const Color primaryLight = Color(0xffbbc0fb);
  static const Color primaryLighter = Color(0xffe7e9ff);

  /// Primary Light
  static const Color primaryDark = Color(0xFFA81735);

  static const Color error = Color(0xCCA81735);

  /// Couleur primaire bordure
  static const Color primaryStroke = Color(0xFFFFD573);

  /// System/error
  static const Color systemErrorColor = Color(0xFFFA5A25);

  /// System blue for cancel btn
  static const Color systemBlueColor = Color(0xFF007AFF);

  static const Color successColor = Color(0xFF46A93D);

  /// Gray
  static const Color gray = Color(0xFFA1A5AC);
  static const Color graySplash = Color(0xBFDADBDC);

  static const primaryColor = Color(0xFF282C5D);
  static const bgCircleColor = Color(0xFFE7E9FF);
  static const moonColor = Color(0xffbbc0fb);
  static const moonColor2 = Color(0xFFE7E9FF);
  static const secondaryColor = Color(0xFF282C5D);
  static const disabledColor = Color(0xFF667085);
  static const backgroundSecondaryColor = Color(0xFFF5F6FF);
  static const backgroundPrimaryColor = Color(0xFFEEF0FF);

  static const TextStyle _defaultStyleLight = TextStyle(
    color: blackColor,
    fontFamily: 'Inter',
  );

  static const TextStyle _defaultStyleDebit = TextStyle(
    color: error,
    fontFamily: 'Inter',
  );

  static const TextStyle _defaultStyleCredit = TextStyle(
    color: brownColor,
    fontFamily: 'Inter',
  );

  static const TextStyle _defaultStyleDark = TextStyle(
    color: whiteColor,
    fontFamily: 'Inter',
  );

  // primary btn height
  static const double btnNormalHeight = 56;
  // primary small btn height
  static const double btnSmallHeight = 38;

  /// Light theme data
  static ThemeData lightBlueTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      foregroundColor: blackColor,
      titleTextStyle: TextStyle(
        color: blackColor,
      ),
      elevation: 0,
    ),
    brightness: Brightness.light,
    primaryColor: primary,
    primaryColorDark: primaryDark,
    secondaryHeaderColor: primaryLight,
    cardColor: const Color(0xFFF6F8FB),
    scaffoldBackgroundColor: whiteColor,
    dialogTheme: const DialogThemeData(
      surfaceTintColor: whiteColor,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: blackColor,
      secondary: primaryLight,
      onSecondary: blackColor,
      tertiary: primaryStroke,
      onTertiary: blackColor,
      error: systemErrorColor,
      onError: blackColor,
      surface: whiteColor,
      onSurface: blackColor,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: blackColor,
        secondary: primaryLight,
        onSecondary: blackColor,
        tertiary: primaryStroke,
        onTertiary: blackColor,
        error: systemErrorColor,
        onError: blackColor,
        surface: whiteColor,
        onSurface: blackColor,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: primary,
    ),
    textTheme: TextTheme(
      // Default / Regular / LargeTitle (Semi)
      titleLarge: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / LargeTitle
      titleMedium: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      // Default / Regular / Title1 et Default / Regular / Title1 (Semi)
      titleSmall: _defaultStyleDark.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: _defaultStyleLight.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _defaultStyleLight.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / Body (Med) / Headline
      headlineSmall: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.53, //26
      ),
      // Default / Regular / Body
      bodyLarge: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5, // 26/17
      ),
      bodyMedium: _defaultStyleLight.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      // Subheadline (med)
      bodySmall: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      // Subheadline
      displayLarge: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4, // 20/15
      ),
      displayMedium: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      // Default / Regular / Footnote
      displaySmall: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: neural04Color,
        height: 1.4, // 18/13
      ),
      labelLarge: _defaultStyleLight.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: _defaultStyleDebit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: _defaultStyleCredit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFFF6F8FB),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
    ),
    // Style des champs inputs de formulaire
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
      fillColor: Color(0xFFF6F8FB),
      filled: true,
      border: InputBorder.none,
      //floatingLabelStyle: textstyle(color: colors.red),
      floatingLabelStyle: TextStyle(
        color: neural04Color,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        //height: 1, // 26/17
      ),
      labelStyle: TextStyle(
        color: neural03Color,
        fontSize: 17,
      ),
      hintStyle: TextStyle(
        color: neural02Color,
        fontSize: 17,
      ),
      //constraints: BoxConstraints(maxHeight: 48),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: primary,
        ),
      ),
      //border: InputBorder.none,
      errorMaxLines: 3,
      errorStyle: TextStyle(
        color: systemErrorColor,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      // icon color
      suffixIconColor: Color(0xFF8b887e),
    ),
    // Bouton elevated
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFFA81735);
            } else if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFF5F5F1);
            } else {
              return primary; // Defer to the widget's default.
            }
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return blackColor; // Defer to the widget's default.
            }
          },
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: blackColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
      ),
    ),
    // Bouton link
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: const WidgetStatePropertyAll(primaryDark),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: primaryDark,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        overlayColor: WidgetStateProperty.all<Color>(primaryLight),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const WidgetStatePropertyAll(Size(55, 26)),
      ),
    ),
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(whiteColor),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          } else {
            return neural01Color;
          }
        },
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return blackColor; // Defer to the widget's default.
            }
          },
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: blackColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
    // Snackbar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: systemErrorColor,
      insetPadding: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
    ),
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      checkColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return whiteColor;
        },
      ),
      side: const BorderSide(
        color: neural02Color,
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    // Chip
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: const TextStyle(
        color: blackColor, // Text color
        fontSize: 14,
        fontWeight: FontWeight.w500, // Text size
      ),
    ),
  );

  /// Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF23211D),
      foregroundColor: whiteColor,
      titleTextStyle: TextStyle(
        color: whiteColor,
      ),
      elevation: 0,
    ),
    primaryColor: primary,
    primaryColorDark: primaryDark,
    secondaryHeaderColor: primaryStroke,
    cardColor: const Color(0xFF23211D),
    scaffoldBackgroundColor: const Color(0xFF2E2B26),
    dialogTheme: const DialogThemeData(
      surfaceTintColor: Color(0xFF2E2B26),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: blackColor,
      secondary: primaryStroke,
      onSecondary: whiteColor,
      tertiary: primaryStroke,
      onTertiary: whiteColor,
      error: systemErrorColor,
      onError: whiteColor,
      surface: Color(0xFF181612),
      onSurface: whiteColor,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: whiteColor,
        secondary: primaryStroke,
        onSecondary: whiteColor,
        tertiary: primaryStroke,
        onTertiary: whiteColor,
        error: systemErrorColor,
        onError: whiteColor,
        surface: Color(0xFF181612),
        onSurface: whiteColor,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: primary,
    ),
    textTheme: TextTheme(
      // Default / Regular / LargeTitle (Semi)
      titleLarge: _defaultStyleDark.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / LargeTitle
      titleMedium: _defaultStyleDark.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      // Default / Regular / Title1 et Default / Regular / Title1 (Semi)
      titleSmall: _defaultStyleDark.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: _defaultStyleDark.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _defaultStyleDark.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / Body (Med) / Headline
      headlineSmall: _defaultStyleDark.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.53, //26
      ),
      // Default / Regular / Body
      bodyLarge: _defaultStyleDark.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5, // 26/17
      ),
      bodyMedium: _defaultStyleDark.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      // Subheadline (med)
      bodySmall: _defaultStyleDark.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      // Subheadline
      displayLarge: _defaultStyleDark.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4, // 20/15
      ),
      displayMedium: _defaultStyleDark.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      // Default / Regular / Footnote
      displaySmall: _defaultStyleDark.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: neural04Color,
        height: 1.4, // 18/13
      ),
      labelLarge: _defaultStyleDark.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: _defaultStyleDebit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: _defaultStyleCredit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFFF6F8FB),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF181612),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
      fillColor: Color(0xFF333333),
      filled: true,
      border: InputBorder.none,
      //floatingLabelStyle: textstyle(color: colors.red),
      floatingLabelStyle: TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 13,
        fontWeight: FontWeight.w400,
        //height: 1, // 26/17
      ),
      labelStyle: TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 17,
      ),
      hintStyle: TextStyle(
        color: Color(0xFFEEEEEE),
        fontSize: 17,
      ),
      //constraints: BoxConstraints(maxHeight: 48),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: primary,
        ),
      ),
      //border: InputBorder.none,
      errorMaxLines: 3,
      errorStyle: TextStyle(
        color: systemErrorColor,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      // icon color
      suffixIconColor: Color(0xFFB1ADA0),
    ),
    // Bouton elevated
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFFA81735);
            } else if (states.contains(WidgetState.disabled)) {
              return const Color(0xFF2E2E2E);
            } else {
              return primary; // Defer to the widget's default.
            }
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFB1ADA0);
            } else {
              return const Color(0xFFFFFFFF);
            }
          },
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: whiteColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
      ),
    ),
    // Bouton link
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: const WidgetStatePropertyAll(primaryDark),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: primaryDark,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        overlayColor: WidgetStateProperty.all<Color>(primaryLight),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const WidgetStatePropertyAll(Size(55, 26)),
      ),
    ),
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(Color(0xFF23211D)),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          } else {
            return neural04Color;
          }
        },
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFB1ADA0);
            } else {
              return whiteColor;
            }
          },
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: whiteColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
    // Snackbar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: systemErrorColor,
      insetPadding: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
    ),
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      checkColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return const Color(0xFF181612);
        },
      ),
      side: const BorderSide(
        color: neural02Color,
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    // Chip
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: const TextStyle(
        color: whiteColor, // Text color
        fontSize: 14,
        fontWeight: FontWeight.w500, // Text size
      ),
    ),
  );

  /// Light Yellow theme data
  static ThemeData lightYellowTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      foregroundColor: blackColor,
      titleTextStyle: TextStyle(
        color: blackColor,
      ),
      elevation: 0,
    ),
    brightness: Brightness.light,
    primaryColor: Color(0xFFF3DC88),
    primaryColorDark: Color(0xFFF3DC88),
    secondaryHeaderColor: Color(0xFFF3DC88),
    cardColor: const Color(0xFFF6F8FB),
    scaffoldBackgroundColor: whiteColor,
    dialogTheme: const DialogThemeData(
      surfaceTintColor: whiteColor,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFF3DC88),
      onPrimary: blackColor,
      secondary: Color(0xFFF3DC88),
      onSecondary: blackColor,
      tertiary: Color(0xFFF3DC88),
      onTertiary: blackColor,
      error: systemErrorColor,
      onError: blackColor,
      surface: whiteColor,
      onSurface: blackColor,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFF3DC88),
        onPrimary: blackColor,
        secondary: Color(0xFFF3DC88),
        onSecondary: blackColor,
        tertiary: Color(0xFFF3DC88),
        onTertiary: blackColor,
        error: systemErrorColor,
        onError: blackColor,
        surface: whiteColor,
        onSurface: blackColor,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: Color(0xFFF3DC88),
    ),
    textTheme: TextTheme(
      // Default / Regular / LargeTitle (Semi)
      titleLarge: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / LargeTitle
      titleMedium: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      // Default / Regular / Title1 et Default / Regular / Title1 (Semi)
      titleSmall: _defaultStyleLight.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: _defaultStyleLight.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _defaultStyleLight.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / Body (Med) / Headline
      headlineSmall: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.53, //26
      ),
      // Default / Regular / Body
      bodyLarge: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5, // 26/17
      ),
      bodyMedium: _defaultStyleLight.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      // Subheadline (med)
      bodySmall: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      // Subheadline
      displayLarge: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4, // 20/15
      ),
      displayMedium: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      // Default / Regular / Footnote
      displaySmall: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: neural04Color,
        height: 1.4, // 18/13
      ),
      labelLarge: _defaultStyleLight.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: _defaultStyleDebit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: _defaultStyleCredit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFFF6F8FB),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
    ),
    // Style des champs inputs de formulaire
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
      fillColor: Color(0xFFF6F8FB),
      filled: true,
      border: InputBorder.none,
      //floatingLabelStyle: textstyle(color: colors.red),
      floatingLabelStyle: TextStyle(
        color: neural04Color,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        //height: 1, // 26/17
      ),
      labelStyle: TextStyle(
        color: neural03Color,
        fontSize: 17,
      ),
      hintStyle: TextStyle(
        color: neural02Color,
        fontSize: 17,
      ),
      //constraints: BoxConstraints(maxHeight: 48),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: Color(0xFFF3DC88),
        ),
      ),
      //border: InputBorder.none,
      errorMaxLines: 3,
      errorStyle: TextStyle(
        color: systemErrorColor,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      // icon color
      suffixIconColor: Color(0xFF8b887e),
    ),
    // Bouton elevated
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFFF3DC88);
            } else if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFF5F5F1);
            } else {
              return Color(0xFFF3DC88); // Defer to the widget's default.
            }
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return blackColor; // Defer to the widget's default.
            }
          },
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: blackColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
      ),
    ),
    // Bouton link
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: const WidgetStatePropertyAll(Color(0xFFF3DC88)),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: Color(0xFFF3DC88),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        overlayColor: WidgetStateProperty.all<Color>(primaryLight),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const WidgetStatePropertyAll(Size(55, 26)),
      ),
    ),
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(whiteColor),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFFF3DC88);
          } else {
            return neural01Color;
          }
        },
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return blackColor; // Defer to the widget's default.
            }
          },
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: blackColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
    // Snackbar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: systemErrorColor,
      insetPadding: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
    ),
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      checkColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return whiteColor;
        },
      ),
      side: const BorderSide(
        color: neural02Color,
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    // Chip
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: const TextStyle(
        color: blackColor, // Text color
        fontSize: 14,
        fontWeight: FontWeight.w500, // Text size
      ),
    ),
  );

  /// Light Blue theme data using one
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      foregroundColor: blackColor,
      titleTextStyle: TextStyle(
        color: blackColor,
      ),
      elevation: 0,
    ),
    brightness: Brightness.light,
    primaryColor: Color(0xFFA81735),
    primaryColorDark: Color(0xFFA81735),
    secondaryHeaderColor: secondaryColor,
    cardColor: const Color(0xFFF6F8FB),
    scaffoldBackgroundColor: whiteColor,
    dialogTheme: const DialogThemeData(
      surfaceTintColor: whiteColor,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFA81735),
      onPrimary: whiteColor,
      secondary: primaryLight,
      onSecondary: blackColor,
      tertiary: Color(0xFFA81735),
      onTertiary: blackColor,
      error: systemErrorColor,
      onError: blackColor,
      surface: whiteColor,
      onSurface: blackColor,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFA81735),
        onPrimary: blackColor,
        secondary: Color(0xFFA81735),
        onSecondary: blackColor,
        tertiary: Color(0xFFA81735),
        onTertiary: blackColor,
        error: systemErrorColor,
        onError: blackColor,
        surface: whiteColor,
        onSurface: blackColor,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: Color(0xFFA81735),
    ),
    textTheme: TextTheme(
      // Default / Regular / LargeTitle (Semi)
      titleLarge: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / LargeTitle
      titleMedium: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      // Default / Regular / Title1 et Default / Regular / Title1 (Semi)
      titleSmall: _defaultStyleLight.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: _defaultStyleLight.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _defaultStyleLight.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / Body (Med) / Headline
      headlineSmall: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.53, //26
      ),
      // Default / Regular / Body
      bodyLarge: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5, // 26/17
      ),
      bodyMedium: _defaultStyleLight.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      // Subheadline (med)
      bodySmall: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      // Subheadline
      displayLarge: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4, // 20/15
      ),
      displayMedium: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      // Default / Regular / Footnote
      displaySmall: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: neural04Color,
        height: 1.4, // 18/13
      ),
      labelLarge: _defaultStyleLight.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: _defaultStyleDebit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: _defaultStyleCredit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFFF6F8FB),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
    ),
    // Style des champs inputs de formulaire
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
      fillColor: Color(0xFFF6F8FB),
      filled: true,
      border: InputBorder.none,
      //floatingLabelStyle: textstyle(color: colors.red),
      floatingLabelStyle: TextStyle(
        color: neural04Color,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        //height: 1, // 26/17
      ),
      labelStyle: TextStyle(
        color: neural03Color,
        fontSize: 17,
      ),
      hintStyle: TextStyle(
        color: neural02Color,
        fontSize: 17,
      ),
      //constraints: BoxConstraints(maxHeight: 48),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: Color(0xFFA81735),
        ),
      ),
      //border: InputBorder.none,
      errorMaxLines: 3,
      errorStyle: TextStyle(
        color: systemErrorColor,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      // icon color
      suffixIconColor: Color(0xFF8b887e),
    ),
    // Bouton elevated
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFFA81735);
            } else if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFF5F5F1);
            } else {
              return Color(0xFFA81735); // Defer to the widget's default.
            }
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return whiteColor; // Defer to the widget's default.
            }
          },
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: whiteColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
      ),
    ),
    // Bouton link
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: const WidgetStatePropertyAll(Color(0xFFA81735)),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color: Color(0xFFA81735),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        overlayColor: WidgetStateProperty.all<Color>(Color(0xFFA81735)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const WidgetStatePropertyAll(Size(55, 26)),
      ),
    ),
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(whiteColor),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFFA81735);
          } else {
            return neural01Color;
          }
        },
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return blackColor; // Defer to the widget's default.
            }
          },
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: blackColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
    // Snackbar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: systemErrorColor,
      insetPadding: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
    ),
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      checkColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return whiteColor;
        },
      ),
      side: const BorderSide(
        color: neural02Color,
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    // Chip
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: const TextStyle(
        color: blackColor, // Text color
        fontSize: 14,
        fontWeight: FontWeight.w500, // Text size
      ),
    ),
  );

  /// Light Green theme data
  static ThemeData lightGreenTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      foregroundColor: blackColor,
      titleTextStyle: TextStyle(
        color: blackColor,
      ),
      elevation: 0,
    ),
    brightness: Brightness.light,
    primaryColor: const Color(0xFF9FF796),
    primaryColorDark: const Color(0xFF7FC077),
    secondaryHeaderColor: const Color(0xFF9FF796),
    cardColor: const Color(0xFFF6F8FB),
    scaffoldBackgroundColor: whiteColor,
    dialogTheme: const DialogThemeData(
      surfaceTintColor: whiteColor,
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF9FF796),
      onPrimary: blackColor,
      secondary: Color(0xFF9FF796),
      onSecondary: blackColor,
      tertiary: Color(0xFF9FF796),
      onTertiary: blackColor,
      error: systemErrorColor,
      onError: blackColor,
      surface: whiteColor,
      onSurface: blackColor,
    ),
    buttonTheme: const ButtonThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF9FF796),
        onPrimary: blackColor,
        secondary: Color(0xFF9FF796),
        onSecondary: blackColor,
        tertiary: Color(0xFF9FF796),
        onTertiary: blackColor,
        error: systemErrorColor,
        onError: blackColor,
        surface: whiteColor,
        onSurface: blackColor,
      ),
    ),
    primaryIconTheme: const IconThemeData(
      color: Color(0xFF9FF796),
    ),
    textTheme: TextTheme(
      // Default / Regular / LargeTitle (Semi)
      titleLarge: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / LargeTitle
      titleMedium: _defaultStyleLight.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
      ),
      // Default / Regular / Title1 et Default / Regular / Title1 (Semi)
      titleSmall: _defaultStyleLight.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: _defaultStyleLight.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: _defaultStyleLight.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // Default / Regular / Body (Med) / Headline
      headlineSmall: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.53, //26
      ),
      // Default / Regular / Body
      bodyLarge: _defaultStyleLight.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.5, // 26/17
      ),
      bodyMedium: _defaultStyleLight.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      // Subheadline (med)
      bodySmall: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      // Subheadline
      displayLarge: _defaultStyleLight.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4, // 20/15
      ),
      displayMedium: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      // Default / Regular / Footnote
      displaySmall: _defaultStyleLight.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: neural04Color,
        height: 1.4, // 18/13
      ),
      labelLarge: _defaultStyleLight.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: _defaultStyleDebit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: _defaultStyleCredit.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Color(0xFFF6F8FB),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
    ),
    // Style des champs inputs de formulaire
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5.0),
      fillColor: Color(0xFFF6F8FB),
      filled: true,
      border: InputBorder.none,
      //floatingLabelStyle: textstyle(color: colors.red),
      floatingLabelStyle: TextStyle(
        color: neural04Color,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        //height: 1, // 26/17
      ),
      labelStyle: TextStyle(
        color: neural03Color,
        fontSize: 17,
      ),
      hintStyle: TextStyle(
        color: neural02Color,
        fontSize: 17,
      ),
      //constraints: BoxConstraints(maxHeight: 48),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: Color(0xFF9FF796),
        ),
      ),
      //border: InputBorder.none,
      errorMaxLines: 3,
      errorStyle: TextStyle(
        color: systemErrorColor,
        fontSize: 12,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: systemErrorColor,
        ),
      ),
      // icon color
      suffixIconColor: Color(0xFF8b887e),
    ),
    // Bouton elevated
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFFA81735);
            } else if (states.contains(WidgetState.disabled)) {
              return const Color(0xFFF5F5F1);
            } else {
              return const Color(0xFF9FF796); // Defer to the widget's default.
            }
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return blackColor; // Defer to the widget's default.
            }
          },
        ),
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: blackColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
      ),
    ),
    // Bouton link
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: const WidgetStatePropertyAll(Color(0xFF7FC077)),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            color:Color(0xFF7FC077),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        overlayColor: WidgetStateProperty.all<Color>(const Color(0xFF7FC077)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const WidgetStatePropertyAll(Size(55, 26)),
      ),
    ),
    // Switch theme
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(whiteColor),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF9FF796);
          } else {
            return neural01Color;
          }
        },
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    // Filled button theme
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return neural03Color;
            } else {
              return blackColor; // Defer to the widget's default.
            }
          },
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: blackColor, // Text color
            fontSize: 17,
            fontWeight: FontWeight.w600, // Text size
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    ),
    // Snackbar
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: systemErrorColor,
      insetPadding: EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
    ),
    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      checkColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return whiteColor;
        },
      ),
      side: const BorderSide(
        color: neural02Color,
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    // Chip
    chipTheme: ChipThemeData(
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: const TextStyle(
        color: blackColor, // Text color
        fontSize: 14,
        fontWeight: FontWeight.w500, // Text size
      ),
    ),
  );

  /// Méthode qui retourne un theme demandé
  static ThemeData get(String? code) {
    //
    if (code == Themes.light.code) {
      return lightTheme;
    }
    else if (code == Themes.dark.code) {
      return darkTheme;
    }
    else if (code == Themes.yellow.code) {
      return lightYellowTheme;
    }
    else if (code == Themes.green.code) {
      return lightGreenTheme;
    }
    else if (code == Themes.blue.code) {
      return lightBlueTheme;
    }
    // Système
    else {
      Brightness systemBrightness =
          PlatformDispatcher.instance.platformBrightness;
      return systemBrightness == Brightness.light ? lightTheme : darkTheme;
    }
  }
}

// }
