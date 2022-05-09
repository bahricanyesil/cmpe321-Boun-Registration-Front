import 'dart:math';

import 'package:flutter/material.dart';

import 'responsiveness_extensions.dart';

/// Theme extension for easy use with context.
extension ThemeExtension on BuildContext {
  /// Current theme of the app.
  ThemeData get theme => Theme.of(this);

  /// Primary color of the theme.
  Color get primaryColor => theme.primaryColor;

  /// Accent/Secondary color of the theme.
  Color get secondaryColor => theme.colorScheme.secondary;

  /// Canvas color of the theme.
  Color get canvasColor => theme.canvasColor.withOpacity(.85);

  /// Primary Light color color of the theme.
  Color get primaryLightColor => theme.primaryColorLight;

  /// Primary Dark color of the theme.
  Color get primaryDarkColor => theme.primaryColorDark;

  /// Large display text style.
  TextStyle get largeDisplay => _getStyle(theme.textTheme.displayLarge, 9);

  /// Medium display text style.
  TextStyle get mediumDisplay => _getStyle(theme.textTheme.displayMedium, 8.2);

  /// Small display text style.
  TextStyle get smallDisplay => _getStyle(theme.textTheme.displaySmall, 7);

  /// Large title text style.
  TextStyle get largeTitle => _getStyle(theme.textTheme.titleLarge, 5.7);

  /// Medium title text style.
  TextStyle get mediumTitle => _getStyle(theme.textTheme.titleMedium, 5.1);

  /// Small title text style.
  TextStyle get smallTitle => _getStyle(theme.textTheme.titleSmall, 4.7);

  /// Large body text style.
  TextStyle get largeBody => _getStyle(theme.textTheme.bodyLarge, 4.5);

  /// Medium body text style.
  TextStyle get mediumBody => _getStyle(theme.textTheme.bodyMedium, 4);

  /// Small body text style.
  TextStyle get smallBody => _getStyle(theme.textTheme.bodySmall, 3.9);

  /// large label text style.
  TextStyle get largeLabel => _getStyle(theme.textTheme.labelLarge, 3.5);

  /// Medium label text style.
  TextStyle get mediumLabel => _getStyle(theme.textTheme.labelMedium, 3.2);

  /// Small label text style.
  TextStyle get smallLabel => _getStyle(theme.textTheme.labelSmall, 3);

  TextStyle _getStyle(TextStyle? style, double factor) {
    final TextStyle defaultStyle = TextStyle(
      fontSize: responsiveSize * factor * .45,
    );
    final TextStyle _style =
        style == null ? defaultStyle : style.merge(defaultStyle);
    return isLandscape
        ? _style.copyWith(fontSize: pow(_style.fontSize ?? 15, 1.18) * 1)
        : _style;
  }
}
