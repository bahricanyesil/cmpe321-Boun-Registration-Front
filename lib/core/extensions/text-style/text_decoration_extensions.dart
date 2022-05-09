import 'package:flutter/material.dart';

/// Text style decoration extensions.
extension TextStyleDecorations on TextStyle {
  /// Underlines the text with a custom style.
  TextStyle underline({double thickness = 1.5, double yOffset = -5}) {
    final Color mainColor = color ?? Colors.black;
    return copyWith(
      shadows: <Shadow>[Shadow(color: mainColor, offset: Offset(0, yOffset))],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationColor: mainColor,
      decorationThickness: thickness,
    );
  }
}
