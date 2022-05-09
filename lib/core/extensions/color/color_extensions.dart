import 'package:flutter/material.dart';

/// Collection of extensions for nullable [Color].
extension NullableColorExtensions on Color? {
  /// Returns the hex value of the color.
  String? get hexValue {
    if (this == null) return null;
    final String value = toString();
    final int firstIndex = value.indexOf('(');
    final int lastIndex = value.lastIndexOf(')');
    return value.substring(firstIndex + 1, lastIndex);
  }
}

/// Extensions for [Color] class
extension ColorExtensions on Color {
  /// Returns the hex value of the color.
  String get hexValueNotNull {
    final String value = toString();
    final int firstIndex = value.indexOf('(');
    final int lastIndex = value.lastIndexOf(')');
    return value.substring(firstIndex + 1, lastIndex);
  }

  /// Makes color more darker.
  Color darken([double amount = .2]) {
    assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');

    final HSLColor hsl = HSLColor.fromColor(this);
    final HSLColor hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Makes color more lighter.
  Color lighten([double amount = .2]) {
    assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');

    final HSLColor hsl = HSLColor.fromColor(this);
    final HSLColor hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}
