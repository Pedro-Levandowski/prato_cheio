import 'package:flutter/material.dart';

abstract final class Cores {
  static const verde = Color(0xFF24594A);
  static const verdeEscuro = Color(0xFF1C3B31);
  static const creme = Color(0xFFF7F4EE);
  static const menta = Color(0xFFE5EEE8);
  static const bege = Color(0xFFEAE5DA);
  static const borda = Color(0xFFE2DDD3);
  static const texto = Color(0xFF66706A);
  static const terracota = Color(0xFFBF5B36);
  static const acafrao = Color(0xFFE6A23C);
  static const erro = Color(0xFFB3412A);
}

ThemeData criarTema() {
  const esquema = ColorScheme(
    brightness: Brightness.light,
    primary: Cores.verde,
    onPrimary: Colors.white,
    primaryContainer: Cores.menta,
    onPrimaryContainer: Cores.verde,
    secondary: Cores.terracota,
    onSecondary: Colors.white,
    secondaryContainer: Cores.menta,
    onSecondaryContainer: Cores.verdeEscuro,
    error: Cores.erro,
    onError: Colors.white,
    surface: Cores.creme,
    onSurface: Cores.verdeEscuro,
    onSurfaceVariant: Cores.texto,
    surfaceContainerLowest: Colors.white,
    surfaceContainerHighest: Cores.bege,
    outline: Color(0xFFCBC5B9),
    outlineVariant: Cores.borda,
  );

  final base = ThemeData(colorScheme: esquema, useMaterial3: true);
  final textos = base.textTheme
      .copyWith(
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1.15,
        ),
        headlineSmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          height: 1.2,
        ),
        titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
        bodyLarge: const TextStyle(fontSize: 16, height: 1.45),
        bodyMedium: const TextStyle(fontSize: 14, height: 1.45),
      )
      .apply(bodyColor: Cores.verdeEscuro, displayColor: Cores.verdeEscuro);

  final cantos = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );
  const textoBotao = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  OutlineInputBorder bordaCampo(Color cor, [double largura = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cor, width: largura),
      );

  return base.copyWith(
    scaffoldBackgroundColor: Cores.creme,
    textTheme: textos,
    appBarTheme: AppBarTheme(
      backgroundColor: Cores.creme,
      foregroundColor: Cores.verdeEscuro,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 16,
      titleTextStyle: textos.titleLarge,
      shape: const Border(bottom: BorderSide(color: Cores.borda)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Cores.borda),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: Cores.texto),
      prefixIconColor: Cores.texto,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: bordaCampo(Cores.borda),
      enabledBorder: bordaCampo(Cores.borda),
      focusedBorder: bordaCampo(Cores.verde, 1.6),
      errorBorder: bordaCampo(Cores.erro),
      focusedErrorBorder: bordaCampo(Cores.erro, 1.6),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: cantos,
        textStyle: textoBotao,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: cantos,
        textStyle: textoBotao,
        foregroundColor: Cores.verde,
        side: const BorderSide(color: Cores.verde),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Cores.verde,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Cores.menta,
      surfaceTintColor: Colors.transparent,
      height: 68,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (estados) => TextStyle(
          fontSize: 12,
          fontWeight: estados.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: estados.contains(WidgetState.selected)
              ? Cores.verdeEscuro
              : Cores.texto,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (estados) => IconThemeData(
          color: estados.contains(WidgetState.selected)
              ? Cores.verde
              : Cores.texto,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Cores.borda, space: 1),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: Cores.verde,
      side: const BorderSide(color: Cores.borda),
      shape: const StadiumBorder(),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      labelStyle: WidgetStateTextStyle.resolveWith(
        (estados) => TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: estados.contains(WidgetState.selected)
              ? Colors.white
              : Cores.verdeEscuro,
        ),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Cores.verdeEscuro,
      actionTextColor: Cores.acafrao,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
