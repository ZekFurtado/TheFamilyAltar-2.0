import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// If you use google_fonts: import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static var textTheme = TextTheme(
    displayLarge: GoogleFonts.figtree(),
    displayMedium: GoogleFonts.figtree(),
    displaySmall: GoogleFonts.figtree(),
    titleLarge: GoogleFonts.figtree(),
    titleMedium: GoogleFonts.figtree(),
    titleSmall: GoogleFonts.figtree(),
    bodyLarge: GoogleFonts.figtree(),
    bodyMedium: GoogleFonts.figtree(),
    bodySmall: GoogleFonts.figtree(),
  );

  // ---- Light Scheme (Parchment + Gold + Navy accents)
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFC9A24A),           // Gold
    onPrimary: Color(0xFF0E1422),         // Navy on gold
    primaryContainer: Color(0xFFF1DFC0),  // Soft gold container
    onPrimaryContainer: Color(0xFF2C2310),

    secondary: Color(0xFF0F1B2D),         // Deep navy for chips/tonals
    onSecondary: Color(0xFFE8E6E1),
    secondaryContainer: Color(0xFF18243A),
    onSecondaryContainer: Color(0xFFE8E6E1),

    tertiary: Color(0xFF6F6BB3),          // Soft purple accent
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFD8D6F4),
    onTertiaryContainer: Color(0xFF201F54),

    error: Color(0xFFBA1A1A),
    onError: Colors.white,

    background: Color(0xFFF5F1E8),        // Parchment
    onBackground: Color(0xFF1A2233),      // Ink

    surface: Colors.white,                // Cards/sheets
    onSurface: Color(0xFF1A2233),
    surfaceVariant: Color(0xFFEEE8DB),    // Dividers
    onSurfaceVariant: Color(0xFF494F58),
    outline: Color(0xFFB9B1A3),

    shadow: Colors.black54,
    scrim: Colors.black54,
    inverseSurface: Color(0xFF1A2233),
    onInverseSurface: Color(0xFFE8E6E1),
    inversePrimary: Color(0xFFE9D8A6),
  );

  // ---- Dark Scheme (Navy + Warm Gold highlights)
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFE9D8A6),           // Lighter gold for dark surfaces
    onPrimary: Color(0xFF1A2233),
    primaryContainer: Color(0xFF4C3F1E),
    onPrimaryContainer: Color(0xFFF7EED4),

    secondary: Color(0xFF0B1320),         // Deep navy
    onSecondary: Color(0xFFE0DED9),
    secondaryContainer: Color(0xFF18243A),
    onSecondaryContainer: Color(0xFFE8E6E1),

    tertiary: Color(0xFFB8B5F0),
    onTertiary: Color(0xFF1B1B1F),
    tertiaryContainer: Color(0xFF3C396F),
    onTertiaryContainer: Color(0xFFE6E5FB),

    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),

    background: Color(0xFF0E1422),        // Brand navy
    onBackground: Color(0xFFE8E6E1),

    surface: Color(0xFF121A2A),
    onSurface: Color(0xFFE8E6E1),
    surfaceVariant: Color(0xFF1A2233),
    onSurfaceVariant: Color(0xFFBFC4CE),
    outline: Color(0xFF6A6F7A),

    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFE8E6E1),
    onInverseSurface: Color(0xFF121A2A),
    inversePrimary: Color(0xFFC9A24A),
  );

  // ---- Optional: Sepia Reading Mode (great for long scripture sessions)
  static ThemeData sepiaTheme() {
    const bg = Color(0xFFF3E8D3);  // Sepia parchment
    const ink = Color(0xFF3B3428); // Warm ink
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightScheme.copyWith(
        background: bg,
        onBackground: ink,
        surface: bg,
        onSurface: ink,
        primary: Color(0xFFC9A24A),
        onPrimary: Color(0xFF0E1422),
        surfaceVariant: Color(0xFFE7DAC1),
        onSurfaceVariant: Color(0xFF5A5142),
        outline: Color(0xFFB9AA8E),
      ),
      scaffoldBackgroundColor: bg,
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        foregroundColor: ink,
        elevation: 0,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFFC9A24A),
        selectionColor: Color(0x33C9A24A),
        selectionHandleColor: Color(0xFFC9A24A),
      ),
    );
  }

  // ---- Base themes with component styling
  static ThemeData light() => _base(lightScheme);
  static ThemeData dark() => _base(darkScheme);

  static ThemeData _base(ColorScheme scheme) {
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.background,
        foregroundColor: scheme.onBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          // fontFamily: GoogleFonts.merriweather().fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: scheme.onBackground,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: scheme.surface,
        margin: const EdgeInsets.all(12),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withOpacity(0.4),
        thickness: 1,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withOpacity(0.2),
        selectionHandleColor: scheme.primary,
      ),
      // If using Google Fonts:
      // textTheme: GoogleFonts.merriweatherTextTheme().apply(
      //   bodyColor: scheme.onSurface,
      //   displayColor: scheme.onSurface,
      // ),
    );

    return theme.copyWith(
      // Scripture-specific styles you can access via Theme.of(context).textTheme
      textTheme: theme.textTheme.copyWith(
        headlineSmall: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700, color: scheme.onBackground),
        titleLarge: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700, color: scheme.onBackground),
        bodyLarge: theme.textTheme.bodyLarge?.copyWith(
          height: 1.45, // comfortable reading
        ),
        bodyMedium: theme.textTheme.bodyMedium?.copyWith(
          height: 1.45,
        ),
        labelSmall: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.2,
        ),
      ),
    );


  }
}