import 'package:flutter/material.dart';

// ============================================================================
// Color Palette
// ============================================================================

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF455A64);      // Dark Blue-Gray
  static const Color secondary = Color(0xFFEDE3D0);    // Cream
  static const Color tertiary = Color(0xFFB2B3AC);     // Light Gray
  static const Color quaternary = Color(0xFF89908C);   // Medium Gray

  // Semantic Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFFF0000);
  static const Color success = Color(0xFF00CC00);

  // Neutral Palette
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surface200 = Color(0xFFF5F5F5);
  static const Color surface300 = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFD0D0D0);

  // Transparent variants
  static const Color primaryLight = Color(0x14455A64);      // 8% opacity
  static const Color primaryDark = Color(0x1F455A64);       // 12% opacity
  static const Color shadowColor = Color(0x19000000);       // 10% opacity
  static const Color shadowColorDark = Color(0x26000000);   // 15% opacity
  static const Color disabledColor = Color(0x6689908C);     // 40% opacity
}

// ============================================================================
// Spacing & Padding Constants
// ============================================================================

class AppSpacing {
  // XS to XXL increments (2dp base unit)
  static const double xs = 4.0;          // Extra Small
  static const double sm = 6.0;          // Small
  static const double md = 12.0;         // Medium
  static const double lg = 16.0;         // Large
  static const double xl = 20.0;         // Extra Large
  static const double xxl = 24.0;        // 2X Large
  static const double xxxl = 28.0;       // 3X Large
  static const double huge = 32.0;       // Huge
  static const double mega = 40.0;       // Mega

  // Screen padding - minimal and premium
  static const double screenPaddingHorizontal = sm;     // 8dp
  static const double screenPaddingVertical = xl;       // 20dp
  static const double screenPaddingTop = xxl;           // 24dp

  // Card padding and spacing
  static const double cardPadding = lg;
  static const double cardSpacing = md;

  // Bottom sheet and dialog
  static const double dialogPadding = xl;
  static const double dialogRadialInset = lg;
}

// ============================================================================
// Border Radius & Elevation
// ============================================================================

class AppBorderRadius {
  static const double sm = 6.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 20.0;
  static const double max = 28.0;

  static final BorderRadius smRadius = BorderRadius.circular(sm);
  static final BorderRadius mdRadius = BorderRadius.circular(md);
  static final BorderRadius lgRadius = BorderRadius.circular(lg);
  static final BorderRadius xlRadius = BorderRadius.circular(xl);
  static final BorderRadius xxlRadius = BorderRadius.circular(xxl);
  static final BorderRadius maxRadius = BorderRadius.circular(max);
}

class AppElevation {
  static const double none = 0.0;
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
}

// ============================================================================
// Typography System
// ============================================================================

class AppTypography {
  static const String _fontFamily = 'BricolageGrotesque';

  // Display / Headline - Large Bold Statements
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    height: 1.22,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: -0.2,
  );

  // Tagline - Smaller Headlines
  static const TextStyle tagline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.39,
    letterSpacing: 0.0,
  );

  // Body Large - Primary Content
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.0,
  );

  // Body Regular - Standard Body Text
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.57,
    letterSpacing: 0.0,
  );

  // Body Small - Secondary Content
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.67,
    letterSpacing: 0.0,
  );

  // Caption - smallest body variant
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    height: 1.45,
    letterSpacing: 0.0,
  );

  // Description - detailed info
  static const TextStyle description = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.54,
    letterSpacing: 0.0,
  );

  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.25,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.57,
    letterSpacing: 0.25,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.67,
    letterSpacing: 0.25,
  );

  // Label Text
  static const TextStyle label = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
  );

  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}

// ============================================================================
// Button Styles
// ============================================================================

class AppButtonStyles {
  // Primary Button - Bold, Full Width, Premium
  static ButtonStyle primaryButton({
    double height = 48.0,
    double borderRadius = 12.0,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.disabledColor,
      disabledForegroundColor: AppColors.quaternary,
      elevation: AppElevation.sm,
      minimumSize: Size(double.infinity, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    );
  }

  // Secondary Button - Outlined Style
  static ButtonStyle secondaryButton({
    double height = 48.0,
    double borderRadius = 12.0,
  }) {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.quaternary,
      backgroundColor: AppColors.white,
      minimumSize: Size(double.infinity, height),
      side: const BorderSide(
        color: AppColors.primary,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    );
  }

  // Tertiary Button - Ghost Style
  static ButtonStyle tertiaryButton({
    double height = 48.0,
    double borderRadius = 12.0,
  }) {
    return TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.quaternary,
      backgroundColor: Colors.transparent,
      minimumSize: Size(double.infinity, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    );
  }

  // Minimal Button - Sleek Variant
  static ButtonStyle minimalButton({
    double height = 40.0,
    double borderRadius = 10.0,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.primary,
      elevation: 0,
      minimumSize: Size(double.infinity, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    );
  }

  // Icon Button - Compact
  static ButtonStyle iconButton({
    double size = 44.0,
  }) {
    return IconButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.primary,
      minimumSize: Size(size, size),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

// ============================================================================
// Card Styles
// ============================================================================

class AppCardStyles {
  // Premium Card with subtle shadow
  static BoxDecoration styleCard({
    Color backgroundColor = AppColors.white,
    double borderRadius = 16.0,
    BoxShadow? customShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        customShadow ??
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
      ],
    );
  }

  // Carousel Card - Sleek Design
  static BoxDecoration carouselCard({
    bool hasBorder = false,
  }) {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20.0),
      border: hasBorder
          ? Border.all(
              color: AppColors.divider,
              width: 1.0,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 12.0,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Minimal Card - Subtle Design
  static BoxDecoration minimalCard({
    Color backgroundColor = AppColors.surface,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(
        color: AppColors.border,
        width: 0.5,
      ),
    );
  }

  // Input Field Card
  static BoxDecoration inputFieldCard({
    bool focused = false,
  }) {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: focused ? AppColors.primary : AppColors.divider,
        width: focused ? 1.5 : 1.0,
      ),
    );
  }
}

// ============================================================================
// Snackbar & Dialog Styles
// ============================================================================

class AppSnackbarStyles {
  static SnackBarThemeData get snackbarTheme => SnackBarThemeData(
        backgroundColor: AppColors.primary,
        contentTextStyle: AppTypography.body.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: AppElevation.md,
        behavior: SnackBarBehavior.floating,
      );

  // Success Snackbar
  static SnackBarThemeData get successSnackbarTheme => SnackBarThemeData(
        backgroundColor: AppColors.success,
        contentTextStyle: AppTypography.body.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: AppElevation.md,
        behavior: SnackBarBehavior.floating,
      );

  // Error Snackbar
  static SnackBarThemeData get errorSnackbarTheme => SnackBarThemeData(
        backgroundColor: AppColors.error,
        contentTextStyle: AppTypography.body.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: AppElevation.md,
        behavior: SnackBarBehavior.floating,
      );
}

class AppDialogStyles {
  static DialogThemeData get dialogTheme => DialogThemeData(
        backgroundColor: AppColors.white,
        elevation: AppElevation.lg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        titleTextStyle: AppTypography.h3.copyWith(
          color: AppColors.primary,
        ),
        contentTextStyle: AppTypography.body.copyWith(
          color: AppColors.quaternary,
        ),
      );

  // Bottom Sheet Theme
  static BottomSheetThemeData get bottomSheetTheme => BottomSheetThemeData(
        backgroundColor: AppColors.white,
        elevation: AppElevation.lg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
      );
}

// ============================================================================
// Side Navigation Bar Styles
// ============================================================================

class AppNavBarStyles {
  static const EdgeInsets navItemPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.md,
  );

  static const EdgeInsets navHeaderPadding = EdgeInsets.all(AppSpacing.xl);

  static BoxDecoration get navBarDecoration => BoxDecoration(
        color: AppColors.white,
        border: Border(
          right: BorderSide(
            color: AppColors.divider,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4.0,
            offset: const Offset(2, 0),
          ),
        ],
      );

  static TextStyle get navItemActive => AppTypography.bodyLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get navItemInactive => AppTypography.body.copyWith(
        color: AppColors.quaternary,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get navItemHover => AppTypography.bodyLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      );
}

// ============================================================================
// Input Field Styles
// ============================================================================

class AppInputStyles {
  static InputDecorationTheme get inputDecoration => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.divider,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.divider,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),
        hintStyle: AppTypography.body.copyWith(
          color: AppColors.quaternary,
        ),
        labelStyle: AppTypography.label.copyWith(
          color: AppColors.primary,
        ),
        errorStyle: AppTypography.caption.copyWith(
          color: AppColors.error,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      );
}

// ============================================================================
// Chip & Tag Styles
// ============================================================================

class AppChipStyles {
  static ChipThemeData get chipTheme => ChipThemeData(
        backgroundColor: AppColors.primaryLight,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.surface,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        labelStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.primary,
        ),
        secondaryLabelStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.white,
        ),
        elevation: 0,
      );
}

// ============================================================================
// Complete Material Theme
// ============================================================================

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.white,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.black,
        onTertiary: AppColors.black,
        onSurface: AppColors.primary,
        onError: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      
      // Appbar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.h3.copyWith(
          color: AppColors.primary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.primary,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTypography.h1,
        displayMedium: AppTypography.h2,
        displaySmall: AppTypography.h3,
        headlineSmall: AppTypography.tagline,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.label,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primaryButton(),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.secondaryButton(),
      ),
      textButtonTheme: TextButtonThemeData(
        style: AppButtonStyles.tertiaryButton(),
      ),

      // Input Fields
      inputDecorationTheme: AppInputStyles.inputDecoration,

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: AppElevation.sm,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),

      // Snackbar
      snackBarTheme: AppSnackbarStyles.snackbarTheme,

      // Dialog
      dialogTheme: AppDialogStyles.dialogTheme,
      bottomSheetTheme: AppDialogStyles.bottomSheetTheme,

      // Chips
      chipTheme: AppChipStyles.chipTheme,

      // FAB
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: AppElevation.md,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.primary,
        size: 24.0,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 0.5,
        space: 1.0,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.quaternary,
        elevation: AppElevation.lg,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.bodySmall.copyWith(
          color: AppColors.quaternary,
        ),
      ),

      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.white,
        elevation: AppElevation.lg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
      ),
    );
  }
}